---
title: Ruby and Jekyll
---

An index generating plugin designed for jekyll.garden.

## Run a generator only once during serve.

```ruby
def generate(site)
  if (!defined?@render_count)
    @render_count = 1
  end

  if @render_count < 1
    Jekyll.logger.info('already fetched data')
    return
  end

  # PROGRAM LOGIC GOES HERE
  # ...
  # ...

  Jekyll.logger.info('    Generation of indexes complete.')
  @render_count = @render_count - 1
end
```

## URL Encode in the New Ruby Version
```ruby
p = URI::Parser.new
p.escape(s)
```

## Overwrite a file
```ruby
# Create a new Jekyll page for the index
File.open(index_path, "w+") do |file|
  file.puts(index_contents)
end
```

## Generate s String Using a Pattern
```ruby
 # Generate a list of each string contained in link
 # In our case we were processing a list of <a> links that had been pre-built from the files in a dir.
index_erb = <<~ERB
  ---
  layout: note
  title: /#{relative_path}
  ---

  <% links.each do |link| %>
    <%= link %>
  <% end %>
ERB

index_path = "#{subdirectory}/index.md"

# Render the ERB template
index_contents = ERB.new(index_erb).result(binding)
```

This is the code in question.
```ruby
# Process each .md file
md_files.each do |md_file|
  if File.basename(md_file, '.md') != 'index'
    permalink = File.join('/', relative_path, File.basename(md_file, '.md'))
    # Generate the link HTML
    link = "<a href='/notes#{parser.escape(permalink)}.html'>#{permalink}</a>"
    # Add the link to the array
    links << link
  end
end
```

And this is what the program is spitting out

```html
---
layout: note
title: /path/to/dir
---


  <a href=''>/path/to/dir/file1.md</a>

  <a href=''>/path/to/dir/file2.md</a>

  <a href=''>/path/to/dir/file3.md</a>

```

