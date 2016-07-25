#!/usr/bin/env ruby

#Author: Mansoor Khan (thisismansoorkhan@gmail.com)
#Date: July 21, 2016
#License: The MIT License (MIT)
#Search for books via GoogleBooksAPI with the specified query

require "bookapp/version"
require 'net/https'
require 'json'
require 'uri'
require 'cgi'

#To temporary disable SSL connect error, uncomment the following line
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

module Bookapp

  class BookSearch

    def search(query ="")
      url = 'https://www.googleapis.com/books/v1/volumes?q='+CGI::escape(query)
      uri = URI(url)
      response = Net::HTTP.get(uri)
      response = JSON.parse(response, symbolize_names: true)

      puts "Books for '#{query}':"
      response[:items].each_with_index do |book, index|
        print index+1, ".  Title: ", book[:volumeInfo][:title], "\n",
              "    Author(s): ", book[:volumeInfo][:authors].map{|author| author}.join(","), "\n"

        print "    Published: ", book[:volumeInfo][:publishedDate], "\n" if book[:volumeInfo][:publishedDate]
        print "    Average Rating: ", book[:volumeInfo][:averageRating], " (",book[:volumeInfo][:ratingsCount], ")", "\n" if book[:volumeInfo][:averageRating]
        print "    Price: ", book[:saleInfo][:retailPrice][:currencyCode]," ", book[:saleInfo][:retailPrice][:amount], "\n" if book[:saleInfo][:retailPrice]
        puts "\n\n"
      end
    end

  end

  # Get the arguments from the command line
  # Call search method with the arguments to search for books
  # with the specified query

  if ARGV.size == 0 || ARGV[0].strip == ""
    puts "Please provide search query as an argument"
  else
    query = ARGV[0].strip
    BookSearch.new.search(query)
  end

end
