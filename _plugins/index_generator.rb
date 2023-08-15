# frozen_string_literal: true
require 'uri'
require 'erb'

Jekyll::Hooks.register :site, :after_init do |site|
  indexer = IndexGenerator.new(true)
  indexer.index(site)
end

class IndexGenerator
  def initialize(debug=nil)
    @parser = URI::Parser.new
    # Silence output of currently processing dir/file
    @verbose_debug = debug || false
    @collection = "notes"
  end

  def debug(message)
    if @verbose_debug == true
      Jekyll.logger.info("[IndexGenerator] #{message}")
    end
  end

  # We only want to run this once. If not it will loop
  # Thanks to code from: stackoverflow.com/questions/68864482/call-jekyll-generator-plugin-only-on-the-first-run-and-not-on-regenerate
  def index(site, collection=nil)
    debug("Generating indexes.")
    # Functional code
    collection ||= @collection
    @collection = @collection
    @source = "#{site.source}/_#{collection}"
    create_index("/")

    # Log completion and lock from running again
    debug("Generation of indexes complete.")
  end

  def add_link(link_array, permalink, title)
    #Jekyll.logger.info(permalink)
    link = "<a href='#{permalink}.html'>#{title}</a>"
    link_array << link
  end

  def create_index(dirpath)
    return "" if dirpath.capitalize.include?("private")

    debug("Indexing dir: #{dirpath}")
    dirpath_full = File.join(@source, dirpath)

    # Initialize an array to store the links
    links_dirs = []
    links_files = []

    # Add an up link if not the root
    if dirpath != "/"
      add_link(links_dirs, "/#{@collection}#{dirpath.gsub(/\/[\w,\s]*[^\/]\z/, "/index")}", "..")
    end

    # Process each entry in the directory
    Dir.foreach(dirpath_full) do |entry|
      next if entry == '.' || entry == '..' || entry == 'index.md' || entry.capitalize.include?("private")

      # Create paths both from source and relative to _notes
      entry_full_path =  File.join(dirpath_full, File.basename(entry, ".md"))
      entry_relative_path = File.join(dirpath, File.basename(entry, ".md"))
      permalink = @parser.escape("/#{@collection}#{entry_relative_path}")

      # Process Dirs
      if File.directory?(entry_full_path)
        add_link(links_dirs, permalink + "/index", entry)
        create_index(entry_relative_path)
        next # if entry was a dir it can't be a file
      end

      # Process Files
      add_link(links_files, permalink, entry)
    end

    # Template for our index.md files based on the links arrays
    index_erb = <<~ERB
    ---
    layout: note
    title: #{dirpath}
    index: true
    ---
    <% if links_dirs.length() > 0 %>
      <h3>Directories</h3>
      <% links_dirs.each do |link| %>
      <%= link %>
      <% end %>
    <% end %>
    <% if links_files.length() > 0 %>
      <h3>Files</h3>
      <% links_files.each do |link| %>
      <%= link %>
      <% end %>
    <% end %>
    ERB
    # Render the ERB template
    index_contents = ERB.new(index_erb).result(binding)

    # New files path
    index_path = "#{dirpath_full}/index.md"
    # Create a new Jekyll page for the index, we need w+ as to overwrite
    File.open(index_path, "w+") do |file|
      file.puts(index_contents)
    end
  end

  def friendly_frontmatter(file)
    content = File.read(file)

    # Check if the file has YAML frontmatter
    if content =~ /\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)/m
      # Extract the YAML frontmatter
      frontmatter = YAML.safe_load(content)

      # Check if the frontmatter has a permalink key
      if frontmatter.key?('permalink')
        # Replace spaces with hyphens in the permalink value
        frontmatter['permalink'] = frontmatter['permalink'].gsub(' ', '-')

        # Update the file content with updated YAML frontmatter
        updated_content = content.sub(/\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)/m, "---\n#{frontmatter.to_yaml}---\n")
        File.open(file, 'w') do |f|
          f.write(updated_content)
        end

        puts "Updated permalink for #{file}"
      end
    end
  end
end
