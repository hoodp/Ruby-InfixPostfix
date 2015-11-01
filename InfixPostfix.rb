#
# InfixPostfix class contains methods for infix to postfix conversion and
# postfix expression evaluation.
#
class InfixPostfix
  
  # converts the infix expression string to postfix expression and returns it
  def infixToPostfix(exprStr)

    # convert the string into an array without spaces
    exprStr = exprStr.split(" ")

    # stack that holds operands and left parens.
    stack = Array.new

    # postfix string that is returned
    postfix = ""

    # loop through each character in the array
    exprStr.each do |c|

      # check if current character is an operator
      if operand? c
        
        # assume value is integer & append to postfix
        postfix += c + " "

      # check for left parenthesis
      elsif isLeftParen? c
        
        # push left parenthesis onto the stack
        stack.push c

      # check for operator
      elsif operator? c
        
        # pop operators with higher stack precedence than the current
        # input value
        while (stackPrecedence stack.last) >= (inputPrecedence c)
          postfix += stack.pop + " "
        end

        # push the operator onto the stack
        stack.push c

      # check for right parenthesis
      elsif isRightParen? c
        
        # output operators until left paren. is reached
        operator = stack.pop()
        while !isLeftParen? operator
          
          # append the operator to the postfix string
          postfix += operator + " "
          operator = stack.pop
        end
      end
    end

    # check the length of the stack
    until stack.empty?
      postfix += stack.pop + " "
    end

    # remove space at the end of the string & return the postfix
    return postfix[0..postfix.length - 2]
  end
  
  # evaluate the postfix string and returns the result
  def evaluatePostfix(exprStr)
    
    # split the string into an array by spaces
    exprStr = exprStr.split(" ");

    # stack the holds 
    stack = Array.new

    # loop through each element in the array
    exprStr.each do |ele|
      
      # check if the current value is an integer
      if operand? ele

        # convert the element to an integer and push onto stack
        stack.push ele.to_i

      # check if current element is an operator
      elsif operator? ele

        # update the ^ operator
        if ele.eql? '^'
          ele = "**"
        end          
        
        # pop the last two elements from the array
        y, x = stack.pop, stack.pop
        
        # calculate the result of the operation
        result = applyOperator(x, y, ele)

        # push the result onto the stack
        stack.push(result)
      end
    end
    return stack.pop
  end
  
  private # subsequent methods are private methods
  
  # returns true if the input is an operator and false otherwise
  def operator?(str)
    return ['+', '-', '*', '/', '%', '^'].include?(str)
  end
  
  # returns true if the input is an operand and false otherwise
  def operand?(str)
    return str.to_i != 0;
  end
  
  # returns true if the input is a left parenthesis and false otherwise
  def isLeftParen?(str)
    return str.eql? '('
  end
  
  # returns true if the input is a right parenthesis and false otherwise
  def isRightParen?(str)
    return str.eql? ')'
  end
  
  # returns the stack precedence of the input operator
  def stackPrecedence(operator)
    if ['+', '-'].include? operator
      return 1
    elsif ['*', '/', '%'].include? operator
      return 2
    elsif '^'.eql? operator
      return 3
    else
      return -1
    end
  end
  
  # returns the input precedence of the input operator
  def inputPrecedence(operator)
    if ['+', '-'].include? operator
      return 1
    elsif ['*', '/', '%'].include? operator
      return 2
    elsif '^'.eql? operator
      return 4
    else
      return 5
    end
  end
  
  # applies the operators to num1 and num2 and returns the result
  def applyOperator(num1, num2, operator)
    return num1.send(operator, num2)
  end
end

#
#  main driver for the program - similar to the main() function in Project 2
#
def main()
  puts "(1) Convert Infix to Postfix Expression"
  puts "(2) Evaluate Postfix Expression"
  puts "(3) Quit"
  puts "Enter Selection (1, 2, or 3): "
  choice = gets.to_i
  if choice == 1
    puts "Enter Infix Expression: "

    # get the infix expression 
    input = gets

    # create new InfixPostfix object
    calc = InfixPostfix.new

    # calculate the postfix and its value
    postfix = calc.infixToPostfix(input)
    value = calc.evaluatePostfix(postfix)

    # output the results
    puts "Postfix: #{postfix}"
    puts "Value: #{value}"
  elsif choice == 2
    puts "Enter Postfix Expression: "

    # get the postfix expression
    input = gets

    # create new infix postfix object & calculate the value
    calc = InfixPostfix.new
    value = calc.evaluatePostfix(input)
    puts "Value: #{value}"
  elsif choice == 3
    puts "Bye."
  else
    puts "Invalid selection. Try again..."
  end
end

# invoke main function
main()
