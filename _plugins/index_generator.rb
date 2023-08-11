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
    start_path = File.join(site.source, "_notes")
    process_directory(start_path, site)

    # Log completion and lock from running again
    Jekyll.logger.info("      IndexGenerator: Generation of indexes complete.")
    @render_count = @render_count - 1
  end

  def process_directory(directory, site)

    Dir.foreach(directory) do |entry|
    # Skip the index, and navigation entries
    next if entry == '.' || entry == '..' || entry == 'index.md'

      # Update path
      full_path = File.join(directory, entry)

      if File.directory?(full_path)
        if @verbos_debug == true
          Jekyll.logger.info("DIR: #{full_path}")
        end
        # Recursively process the subdirectory
        process_directory(full_path, site)
        next
      end

      if @verbos_debug == true
        Jekyll.logger.info("DIR: #{full_path}")
      end
      create_index(directory, site)
    end
  end

  def add_link(link_array, link_rel_path, prefix, suffix)
    md_suffix = ".md"
    if suffix == ""
      md_suffix = ""
    end
    link = "<a href='#{prefix}/#{link_rel_path}#{suffix}'>./#{link_rel_path}#{md_suffix}</a>"
    link_array << link
  end

  def create_index(directory, site)
    relative_path = Pathname.new(directory).relative_path_from(Pathname.new(site.source + "/_notes"))
    # Get all .md files within the subdirectory
    # Initialize an array to store the links
    links_dirs = []

    links_files = []

    dirsEndedFlag = false
    # Process each entry in the directory
    Dir.foreach(directory) do |entry|
    next if entry == '.' || entry == '..' || entry == 'index.md'

      # New fullpath
      entry_full_path =  File.join(directory, entry)

      if File.directory?(entry_full_path)
        entry_relative_path = Pathname.new(entry_full_path).relative_path_from(Pathname.new(site.source + "/_notes"))
        # add entry to dir array
        add_link(links_dirs, entry_relative_path, "/notes", "")
        next # if entry was a dir it can't be a file
      end

      entry_full_path =  File.join(directory, File.basename(entry, ".md"))
      entry_relative_path = Pathname.new(entry_full_path).relative_path_from(Pathname.new(site.source + "/_notes"))
      # Add the link to the file array
      add_link(links_files, entry_relative_path, "/notes", ".html")
    end

  # Generate the index.html content using the template

    index_erb = <<~ERB
    ---
    layout: note
    title: /#{relative_path}
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
end
