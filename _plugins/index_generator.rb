# frozen_string_literal: true
require 'uri'

class IndexGenerator < Jekyll::Generator
  safe true
  priority :highest
  def generate(site)
    if (!defined?@render_count)
      @render_count = 1
    end

    if @render_count < 1
      Jekyll.logger.info('already fetched data')
      return
    end
    start_path = File.join(site.source, '_notes')
    process_directory(start_path, site)
    Jekyll.logger.info('    Generation of indexes complete.')
    @render_count = @render_count - 1
  end

  def process_directory(directory, site)

    Dir.foreach(directory) do |entry|
    next if entry == '.' || entry == '..' || entry == 'index.md'

      full_path = File.join(directory, entry)

      create_index(directory, site)

      if File.directory?(full_path)
        # Perform your desired function on the directory
        # ...
        subdirectories = Dir.glob(full_path).select { |f| File.directory?(f) }
        # Recursively process the subdirectory
        process_directory(full_path, site)
        next
      end
    end
  end

  def create_index(directory, site)
    parser = URI::Parser.new
    relative_path = Pathname.new(directory).relative_path_from(Pathname.new(site.source + "/_notes"))
    # Get all .md files within the subdirectory

    # Initialize an array to store the links
    links = []

    Dir.foreach(directory) do |entry|
    next if entry == '.' || entry == '..' || entry == 'index.md'
      # Generate the link HTML
      entry_full_path = File.join(directory, entry)
      if File.directory?(entry_full_path)
        entry_relative_path = Pathname.new(entry_full_path).relative_path_from(Pathname.new(site.source + "/_notes"))
        link = "<a href='/notes/#{entry_relative_path}/'>#{entry_relative_path}</a>"
        links << link
        next
      end
      entry_full_path =  File.join(directory, File.basename(entry, '.md'))
      entry_relative_path = Pathname.new(entry_full_path).relative_path_from(Pathname.new(site.source + "/_notes"))
      # Add the link to the array
      link = "<a href='/notes/#{entry_relative_path}.html'>#{entry_relative_path}.md</a>"
      links << link
    end

    # Generate the index.html content using the template
    index_erb = <<~ERB
    ---
    layout: note
    title: /#{relative_path}
    index: true
    ---
    <% links.each do |link| %>
      <%= link %>
    <% end %>
    ERB
    index_path = "#{directory}/index.md"

    # Render the ERB template
    index_contents = ERB.new(index_erb).result(binding)

    # Create a new Jekyll page for the index
    File.open(index_path, "w+") do |file|
      file.puts(index_contents)
    end
  end
end
