require "json"
require "rest-client"

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ("A".."Z").to_a.sample
    end
  end

  def score
    @word = params[:word].upcase
    @letters = params[:letters].split(" ")
    if !possible_word?(@letters, @word)
      @score = "Sorry but #{@word.upcase} can't be built out of #{@letters.join(', ')}"
    elsif !valid_english_word?(@word)
      @score = "Sorry but #{@word.upcase} does not seem to be a valid English word..."
    else
      @score = "Congratulations! #{@word.upcase} is a valid English word!"
    end
  end

  def possible_word?(grid, word)
    available_letters = grid
    p available_letters
    p word
    word.split('').each do |letter|
      if available_letters.include?(letter)
        available_letters.delete_at(available_letters.index(letter))
      else
        return false
      end
    end
    return true
  end

  def valid_english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}.json"
    api_answer = RestClient.get(url, headers = {})
    parsed_api_answer = JSON.parse(api_answer)
    return parsed_api_answer["found"]
  end
end
