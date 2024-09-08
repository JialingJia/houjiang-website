require 'bibtex'

module Jekyll
  class FetchDoiTag < Liquid::Tag
    def initialize(tag_name, citation_key, tokens)
      super
      @citation_key = citation_key.strip
    end

    def render(context)
      site = context.registers[:site]
      
      # Load the bibliography file from the `_bibliography` folder
      bibliography_file = File.join(site.source, '_bibliography', 'references.bib')
      
      # Check if the file exists
      return 'Bibliography file not found.' unless File.exist?(bibliography_file)

      # Load and parse the BibTeX file
      bib_data = File.read(bibliography_file)
      bib_entries = BibTeX.parse(bib_data)
      
      # Find the entry by citation key and return the DOI
      entry = bib_entries.find { |e| e.key == @citation_key }
      entry ? entry.doi.to_s : 'DOI not found.'
    end
  end
end

Liquid::Template.register_tag('fetch_doi', Jekyll::FetchDoiTag)
