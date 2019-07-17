require 'json'
require 'time'
require 'securerandom'

source = ARGV[0] || "notes"

simplenotes = JSON.load(File.read("#{source}/source/notes.json"))
standardnotes = { "items" => [ ] }
tags = { }
NOW = Time.now.utc.iso8601(3)


def convert(simplenote, tags, trashed: false)
  id = simplenote["id"]
  uuid = "#{id[0..7]}-#{id[8..11]}-#{id[12..15]}-#{id[16..19]}-#{id[20..31]}"
  title, content = simplenote["content"].split("\r\n", 2)
  preview = if content.strip.chars.length > 80
    content.strip.chars[0...80].join('').strip + "…"
  else 
    content.strip
  end
  simplenote["tags"].each do |tag|
    tag.strip!
    unless tag.empty?
      if not tags[tag]
        tags[tag] = {
          "uuid" => SecureRandom.uuid,
          "content_type" => "Tag",
          "created_at" => NOW,
          "updated_at" => NOW,
          "content" => {
            "title" => tag,
            "references" => [
            ]
          }
        }
      end
      tags[tag]["content"]["references"] << {
        "uuid" => uuid,
        "content_type" => "Note"
      }
    end
  end if simplenote["tags"]
  
  {
    "uuid" => uuid,
    "created_at" => simplenote["creationDate"],
    "updated_at" => simplenote["lastModified"],
    "content_type" => "Note",
    "content" => {
      "title" => title.strip,
      "text" => content.strip,
      "references" => [],
      "trashed" => trashed,
      "preview_plain" => preview,
      "preview_html" => nil,
      "appData": {
        "org.standardnotes.sn": {
          "client_updated_at": simplenote["lastModified"]
        }
      }
    }
  }
end

activenotes = simplenotes["activeNotes"].map do |simplenote| 
  convert(simplenote, tags, trashed: false)
end

trashednotes = simplenotes["trashedNotes"].map do |simplenote| 
  convert(simplenote, tags, trashed: true)
end

standardnotes["items"].concat( activenotes, trashednotes, tags.values )

puts JSON.pretty_generate( standardnotes )
