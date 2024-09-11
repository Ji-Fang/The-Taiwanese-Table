require "nokogiri"
require "date"
require "open-uri"

# Clear existing data
PostCategory.destroy_all
Photo.destroy_all
Post.destroy_all
Category.destroy_all

file_path = Rails.root.join("app", "assets", "wordpress-export.xml")
file = File.open(file_path)
doc = Nokogiri::XML(file)

puts "Starting to seed data..."

last_post = nil

doc.xpath("//item").each_with_index do |item, index|
  puts "Processing item ##{index + 1}"

  # Extract item type from the post_type field
  post_type = item.xpath("wp:post_type").text.strip

  # Skip non-post items (e.g., images)
  next if post_type != "post"

  title = item.xpath("title").text.strip
  content = item.xpath("content:encoded").text.strip
  pub_date = item.xpath("pubDate").text.strip
  youtube_url = content.match(/https:\/\/youtu.be\/\S+/)&.to_s
  post_date = DateTime.parse(pub_date) rescue nil

  # Extract categories
  category_names = item.xpath("category[@domain='category']").map(&:text).map(&:strip).reject(&:empty?)
  categories = category_names.map do |name|
    Category.find_or_create_by(name: name)
  end

  # Create or update the post
  post = Post.find_or_create_by(
    title: title,
    content: content,
    youtube_url: youtube_url,
    published_at: post_date
  )

  # Create associations if categories are present
  if post.persisted? && categories.any?
    categories.each do |category|
      PostCategory.find_or_create_by(post: post, category: category)
    end
    puts "Post '#{title}' created with categories: #{categories.map(&:name).join(', ')}"
  else
    puts "No valid categories found for post '#{title}'" if categories.empty?
  end

  # Set the last post as the current one
  last_post = post

  # Extract the image URL from the postmeta
  image_id = item.xpath("wp:postmeta[wp:meta_key='_thumbnail_id']/wp:meta_value").text.strip
  image_url = "https://thetaiwanesetablecom.wordpress.com/wp-content/uploads/#{image_id}.jpg" if image_id.present?

  if image_url.present? && last_post
    Photo.create(post: last_post, image_url: image_url)
    puts "Photo created for post '#{last_post.title}' with URL: #{image_url}"
  end
end

file.close
puts "Seeding completed."
