User.delete_all
Book.delete_all
Author.delete_all
Category.delete_all
Favorite.delete_all

book_data = JSON.parse(open('db/books.json').read)
author_data = JSON.parse(open('db/authors.json').read)
category_data = JSON.parse(open('db/category.json').read)


book_data.each do |book_hash|
  book = Book.new
  book.isbn = book_hash['isbn']
  book.name = book_hash['name']
  book.year = book_hash['year']
  book.rating = book_hash['rating']
  book.image = book_hash['image']
  book.description = book_hash['description']
  book.save
  puts "#{book.name}(#{book.isbn}) saved."
end

puts "Books saved"

category_data.each do |category_hash| 
  category = Category.find_by(name: category_hash['category'])
  if category == nil
    category = Category.new
    category.name = category_hash['category']
    category.save
    puts "#{category.name} added"
  end
  puts "#{category_hash['isbn']}"
  book = Book.find_by(isbn: category_hash['isbn'])
  book.category = category
  book.save
end

author_data.each do |author_hash|
  author = Author.find_by(name: author_hash['author'])
  if author == nil
    author = Author.new
    author.name = author_hash['author']
    author.save
    puts "#{author.name} added"
  end
  book = Book.find_by(isbn: author_hash['isbn'])
  book.author = author
  book.save
end

puts "Seeded succesfully."
