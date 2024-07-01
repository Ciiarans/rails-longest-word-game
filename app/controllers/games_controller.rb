class GamesController < ApplicationController
  require 'open-uri'
  require 'json'

  def score
    word = params[:word]
    grid = params[:grid]

    if grid.nil?
      @message = "Error: Grid parameter is missing."
    else
      grid = JSON.parse(grid)
      if !word_in_grid?(word, grid)
        @message = "The word cannot be built out of the original grid."
      elsif !valid_english_word?(word)
        @message = "The word is valid according to the grid, but is not a valid English word."
      else
        @message = "The word is valid according to the grid and is a valid English word."
      end
    end
  end

  private

  def word_in_grid?(word, grid)
    return false if word.nil? || grid.nil?

    word.chars.all? { |letter| word.count(letter) <= grid.count(letter) }
  end

  def valid_english_word?(word)
    return false if word.nil?

    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    response = open(url).read
    json = JSON.parse(response)
    json['found']
  end
end
