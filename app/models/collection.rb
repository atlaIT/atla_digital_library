# Generated by curation_concerns:models:install
class Collection < ActiveFedora::Base
  include ::CurationConcerns::CollectionBehavior
  # You can replace these metadata if they're not suitable
  include CurationConcerns::BasicMetadata

  property :institution, predicate: ::RDF::Vocab::FOAF.based_near do |index|
    index.as :stored_searchable
  end

  property :pub_place, predicate: ::RDF::Vocab::DC.Location do |index|
    index.as :stored_searchable
  end

  # required
  property :file_name, predicate: ::RDF::Vocab::DC.MediaTypeOrExtent do |index|
    index.as :stored_searchable
  end

  # required
  property :name_code, predicate: ::RDF::Vocab::DC.identifier do |index|
    index.as :stored_searchable
  end
end
