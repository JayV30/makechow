module ApplicationHelper
  
  def hours_in_number(number)
    number/60
  end
  
  def minutes_in_number(number)
    number%60
  end
  
end
