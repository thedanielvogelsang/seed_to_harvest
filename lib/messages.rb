module Messages
  Q1_VEG_TYPE = 'What type of vegetable did you plant?'
  Q2_VARIETAL_NAME = 'Do you know the varietal name? (y/n)'
  OK_CALLED = 'Ok. What was it called?'
  Q3_PLANTING_DATE = 'When did you plant it? (dd/mm)'
  E1 = 'Whoops! Thats not a valid answer.'
  VARIETAL_NOT_FOUND = 'We dont have that varietal name in our system. Are you sure you spelled it correctly? (y/n)'
  NO_VARIETAL_ENTERED = "That's okay! We can always find out that information later. For now, let's continue..."
  NO_VARIETAL_MATCH = 'Hm. Still cant find a match. Lets skip for now and come back later.'
  E4_NO_VEGETABLE_FOUND = 'Sorry! We couldnt find that vegetable. Would you like to continue? (y/n)'
  FAILED_DATE_PARSE = "Whoops! That doesn't match our syntax. Try it like this: 'dd/mm' (eg. 15/07 or 2/11)"
  SUCCESSFUL_VARIETAL_MATCH = 'Nice! We did it. Lets continue...'
  SUCCESSFUL_ADDITION = 'We added your vegetable to the database. Would you like to continue? (y/n)'

  def varietal_list(varietal_list_sym, veg_name)
    varietal_count = varietal_list_sym.size
    varietal_names = varietal_list_sym.map(&:to_s)
    varietal_sentence = "Darn. We have only the following #{veg_name} varieties: "

    varietal_samples = Hash.new
    1..varietal_count do |n|
      varietal_name = varietal_names[n-1]
      varietal_samples[n] = varietal_name
      varietal_sentence += "(#{n}) #{varietal_name}"
      unless n = varietal_count
        varietal_sentence += ', '
      else
        varietal_sentence += '. '
      end
    end

    varietal_sentence += "\n\nPlease select from the above list if any are correct."

    puts varietal_sentence
    a5 = gets.chomp.to_i

    varietal_samples.keys.include?(a5) ? varietal_samples[a5] : nil
  end
end