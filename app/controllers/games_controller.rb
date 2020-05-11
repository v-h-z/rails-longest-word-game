require 'open-uri'

class GamesController < ApplicationController
  def new
    @tirage = []
    10.times { @tirage << ('a'..'z').to_a.sample }
    @tirage
  end

  def score
    word_list = params[:word_list].split(',')
    played_word = params[:word]
    p api_resp = find_word(played_word)
    @result = if api_resp['found'] == true
                counter = 0
                played_word.chars.each do |letter|
                  p letter
                  if word_list.include?(letter)
                    counter += 1
                    word_list.delete(letter)
                  end
                end
                counter == played_word.size ? 'Bravo! this is correct' : 'nope..the word exists but is not included in the chars provided'
              else
                'this word doesnt exist sorry.. you lost'
              end
    @word_list = word_list.join(',')
    @played_word = played_word
    if @result == 'Bravo! this is correct'
      @score = played_word.size
    else
      @score = 0
    end
    cookies[:score] = @score + cookies[:score].to_i
    @total_score = cookies[:score]
  end

  private

  def request_api(url)
    response = open(url).read

    JSON.parse(response)
  end

  def find_word(word)
    request_api(
      "https://wagon-dictionary.herokuapp.com/#{word}"
    )
  end
end
