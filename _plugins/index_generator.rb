# frozen_string_literal: true
require 'uri'
require 'erb'

class IndexGenerator < Jekyll::Generator
  safe true
  priority :highest

  # We only want to run this once. If not it will loop
  # Thanks to code from: stackoverflow.com/questions/68864482/call-jekyll-generator-plugin-only-on-the-first-run-and-not-on-regenerate
  def generate(site)
    # Check if already ran and update run count
    if (!defined?@render_count)
      @render_count = 1
    end
    if @render_count < 1
      Jekyll.logger.info("      IndexGenerator: Already generated once, restart to refresh index pages.")
      return
    end

    @parser = URI::Parser.new

    # Silence output of currently processing dir/file
    @verbos_debug = false

    # Functional code
    start_path = File.join(site.source, "_notes/")
    create_index(start_path, site)

    # Log completion and lock from running again
    Jekyll.logger.info("      IndexGenerator: Generation of indexes complete.")
    @render_count = @render_count - 1
  end

  def add_link(link_array, link_rel_path, suffix)
    permalink = @parser.escape("/note/#{link_rel_path}/")
    if suffix == "/"
      permalink = permalink + "index/"
    end
    #Jekyll.logger.info(permalink)
    link = "<a href='#{permalink}'>/#{link_rel_path}#{suffix}</a>"
    link_array << link
  end

  def create_index(directory, site)
    Jekyll.logger.info("Indexing: #{directory}")
    # Initialize an array to store the links
    links_dirs = []

    links_files = []

    dirsEndedFlag = false
    # Process each entry in the directory
    Dir.foreach(directory) do |entry|
    next if entry == '.' || entry == '..' || entry == 'index.md'
      # New fullpath
      entry_full_path =  File.join(directory, File.basename(entry, ".md"))
      entry_relative_path = Pathname.new(entry_full_path).relative_path_from(Pathname.new(site.source + "/_notes"))
      if File.directory?(entry_full_path)
        # add entry to dir array
        add_link(links_dirs, entry_relative_path, "/")
        create_index(entry_full_path, site)
        next # if entry was a dir it can't be a file
      end
      # Add the link to the file array
      add_link(links_files, entry_relative_path, ".md")
    end

  # Generate the index.html content using the template
    relative_path = "/#{Pathname.new(directory).relative_path_from(Pathname.new(site.source + "/_notes"))}/"
    if relative_path == '/./'
      relative_path = '/'
    end

    index_erb = <<~ERB
    ---
    layout: note
    title: #{relative_path}index/

    index: true
    ---
    <h3>Directories</h3>
    <% links_dirs.each do |link| %>
    <%= link %>
    <% end %>
    <h3>Files</h3>
    <% links_files.each do |link| %>
    <%= link %>
    <% end %>
    ERB

    index_path = "#{directory}/index.md"

    # Render the ERB template
    index_contents = ERB.new(index_erb).result(binding)

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
