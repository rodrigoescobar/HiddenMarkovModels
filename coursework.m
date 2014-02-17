function [my_roll_one,my_roll_two,task_two,posterior] = coursework(T)

% Every variable that has even in the name corresponds to model 1 and odd
% corresponds to model 2

% load the rolls.mat file containing roll_one, roll_two, roll_three
load rolls roll_one;
load rolls roll_two;
load rolls roll_three;
% Task one
% Generate my_roll_one and my_roll_two
% your code here!

% initializes the posterior array
posterior = zeros(10,100);

evenNumbers = [2 4 6];
oddNumbers = [1 3 5];

my_roll_one = zeros(1,T);
my_roll_two = zeros(1,T);

% randomises the first state to be selected.
state = randi(2);

% the T parameter will be the length of the my_roll_one and my_roll_two
% matrixes
for n = 1:T
    
    % this randomises the probability for the first number to be got from
    % the die.
    prob = rand(1);
    
    % this selects the initial state of each one of the rolls.
    if state == 1
        number1 = randi(6);
        number2 = randi(6);
        my_roll_one(1, n) = number1;
        my_roll_two(1, n) = number2;
        if prob > 0.8
            state = 2;
        end
    else
        number1 = randi(3);
        number2 = randi(3);
        
        % this selectes randomly the first number for each die.
        if prob < 1/6
            my_roll_one(1, n) = oddNumbers(1, number1);
            my_roll_two(1, n) = evenNumbers(1, number2);
        else
            my_roll_one(1, n) = evenNumbers(1, number1);
            my_roll_two(1, n) = oddNumbers(1, number2);
            
        end
        if prob > 0.9
            state = 1;
        end
    end
    
end

% if T is less than a hundred my_roll_one and my_roll_two are filled with
% 0s to compensate. This will be used in task 3.

defficit = 100-T;
mat = zeros(1, defficit);
my_roll_one = horzcat(my_roll_one, mat);
my_roll_two = horzcat(my_roll_two, mat);

% Task two
% Use forward algorithm to calculate probabilities
% remember to store them in the array in the order that they are described
% in the coureswork document, and comment on them in your pdf file.


% 2 functions are created in this section: probabilities() which is the
% forward algorithm and backwards_algorithm()
% this functions fill matrixes to be used in task 3 as well in task 2.

% this initialises the task_two matrix
task_two = 1:10;



% the probabilities() function (forward_algorithm) is called and the outputs
% are stored in variables.
[forward_matrix_even_roll_one, forward_matrix_odd_roll_one, even_probability_roll_one, odd_probability_roll_one] = probabilities(roll_one);
[forward_matrix_even_roll_two, forward_matrix_odd_roll_two, even_probability_roll_two, odd_probability_roll_two] = probabilities(roll_two);
[forward_matrix_even_roll_three, forward_matrix_odd_roll_three, even_probability_roll_three, odd_probability_roll_three] = probabilities(roll_three);
[forward_matrix_even_my_roll_one, forward_matrix_odd_my_roll_one, even_probability_my_roll_one, odd_probability_my_roll_one] = probabilities(my_roll_one);
[forward_matrix_even_my_roll_two, forward_matrix_odd_my_roll_two, even_probability_my_roll_two, odd_probability_my_roll_two] = probabilities(my_roll_two);


% some of the outputs are used to fill the task_two array and task 2 is
% finished.
task_two(1) = even_probability_my_roll_one;
task_two(2) = even_probability_my_roll_two;
task_two(3) = even_probability_roll_one;
task_two(4) = even_probability_roll_two;
task_two(5) = even_probability_roll_three;
task_two(6) = odd_probability_my_roll_one;
task_two(7) = odd_probability_my_roll_two;
task_two(8) = odd_probability_roll_one;
task_two(9) = odd_probability_roll_two;
task_two(10) = odd_probability_roll_three;

    % FORWARD ALGORITHM
    % this function follows the forward algorithm and outouts the
    % probability of each one of the die to be used, and matrixes for each
    % one of the probabilities per value in the sequence to be output from
    % each dice.
    function [forward_matrix_even, forward_matrix_odd, evenProbability, oddProbability] = probabilities(array)
        
        % initialises the matrixes that will contain the probability of each
        % number in the sequence to be output from the die.
        forward_matrix_even = zeros(2,length(array));
        forward_matrix_odd = zeros(2,length(array));
        
        % matrix for the transitions to make code more readable
        transition = [0.8, 0.2 ; 0.1, 0.9];
        
        % initial probability for the sequences
        state_one_even = 0.5 * 1/6;
        state_one_odd = 0.5 * 1/6;
        
        if (array(1) == 2) || (array(1) == 4) || (array(1) == 6)
            state_two_even = 0.5 * 5/18;
            state_two_odd = 0.5 * 1/18;
        else
            state_two_even = 0.5 * 1/18;
            state_two_odd = 0.5 * 5/18;
        end
        
        % fills the first  value in the matrixes
        forward_matrix_even(1,1) = state_one_even;
        forward_matrix_even(2,1) = state_two_even;
        
        forward_matrix_odd(1,1) = state_one_odd;
        forward_matrix_odd(2,1) = state_two_odd;
        
        
        % it iterates through the matrix following the forward algorithm
        % and storing the probabilities got
        for position = 2:length(array)
            
            old_state_one_even = state_one_even;
            old_state_one_odd = state_one_odd;
            
            state_one_even = (old_state_one_even * transition(1,1) * 1/6) + (state_two_even * transition(2,1) * 1/6);
            state_one_odd = (old_state_one_odd * transition(1,1) * 1/6) + (state_two_odd * transition(2,1) * 1/6);
            
            if (array(position) == 2) || (array(position) == 4) || (array(position) == 6)
                state_two_even = (state_two_even * transition(2,2) * 5/18) + (old_state_one_even * transition(1,2) * 5/18);
                state_two_odd = (state_two_odd * transition(2,2) * 1/18) + (old_state_one_odd * transition(1,2)* 1/18);
            else
                state_two_even = (state_two_even * transition(2,2) * 1/18) + (old_state_one_even * transition(1,2) * 1/18);
                state_two_odd = (state_two_odd * transition(2,2) * 5/18) + (old_state_one_odd * transition(1,2)*5/18);
            end
            
            
            forward_matrix_even(1, position) = state_one_even;
            forward_matrix_even(2, position) = state_two_even;
            
            forward_matrix_odd(1, position) = state_one_odd;
            forward_matrix_odd(1, position) = state_two_odd;
        end
        
        % this are the values to be passed to the task_two matrix.
        evenProbability = state_one_even+state_two_even;
        oddProbability = state_one_odd+state_two_odd;
    end


    % BACKWARDS ALGORITHM
    % follows a similar structure to the Forward alrogithm function but
    % with less outputs.
    function [backwards_matrix_even, backwards_matrix_odd] = backwards_algorithm(array)
        
        % transition matrix declared for easier readeability 
        transition = [0.8, 0.2 ; 0.1, 0.9];
        
        % declares and inittialises the output matrixes
        backwards_matrix_even = zeros(2,length(array));
        backwards_matrix_odd = zeros(2,length(array));
        
        % first states of the backwardsalgorithm have 100% probability of
        % start.
        state_one_even = 1/6;
        state_one_odd = 1/6;
        
        if (array(length(array)) == 2) || (array(length(array)) == 4) || (array(length(array)) == 6)
            state_two_even = 5/18;
            state_two_odd = 1/18;
        else
            state_two_even = 1/18;
            state_two_odd = 5/18;
        end
        backwards_matrix_even(1,length(array)) = state_one_even;
        backwards_matrix_even(2,length(array)) = state_two_even;
        
        backwards_matrix_odd(1,length(array)) = state_one_odd;
        backwards_matrix_odd(2,length(array))= state_two_odd;
        
        % iterates following the backwards algorithm and store the results
        % of each iterations in the matrixes previously declared.
        for position = length(array)-1:-1:1
            
            old_state_one_even = state_one_even;
            old_state_two_even = state_two_even;
            
            old_state_one_odd = state_one_odd;
            old_state_two_odd = state_two_odd;
            
            if (array(position+1) == 2) || (array(position+1) == 4) || (array(position+1) == 6)
                state_one_even = (old_state_one_even * transition(1,1) * 1/6) + (old_state_two_even * transition(1,2) * 5/18);
                state_one_odd = (old_state_one_odd * transition(1,1) * 1/6) + (old_state_two_odd * transition(1,2) * 1/18);
                
                state_two_even = (old_state_two_even * transition(2,2) * 5/18) + (old_state_one_even * transition(2,1) * 1/6);
                state_two_odd = (old_state_two_odd * transition(2,2) * 1/18) + (old_state_one_odd * transition(2,1)* 1/18);
            else
                state_one_even = (old_state_one_even * transition(1,1) * 1/6) + (old_state_two_even * transition(1,2) * 1/18);
                state_one_odd = (old_state_one_odd * transition(1,1) * 1/6) + (old_state_two_odd * transition(1,2) * 5/18);
                
                state_two_even = (old_state_two_even * transition(2,2) * 1/18) + (old_state_one_even * transition(2,1) * 1/6);
                state_two_odd = (old_state_two_odd * transition(2,2) * 5/18) + (old_state_one_odd * transition(2,1)*5/18);
            end
            
            backwards_matrix_even(1,position) = state_one_even;
            backwards_matrix_even(2,position) = state_two_even;
            
            backwards_matrix_odd(1,position) = state_one_odd;
            backwards_matrix_odd(2,position)= state_two_odd;
        end
    end

% calls the function on each one of the rolls and outputs values for each
% one of them.
[backwards_matrix_even_roll_one, backwards_matrix_odd_roll_one] = backwards_algorithm(roll_one);
[backwards_matrix_even_roll_two, backwards_matrix_odd_roll_two] = backwards_algorithm(roll_two);
[backwards_matrix_even_roll_three, backwards_matrix_odd_roll_three] = backwards_algorithm(roll_three);
[backwards_matrix_even_my_roll_one, backwards_matrix_odd_my_roll_one] = backwards_algorithm(my_roll_one);
[backwards_matrix_even_my_roll_two, backwards_matrix_odd_my_roll_two] = backwards_algorithm(my_roll_two);



% Task three
% for each of the 5 die rolls (your two and the 3 loaded ones)
% and for each model
% work out the most probable hidden state for each timestep and store this
% in the posterior matrix
% list the 5 rolls for model one first, then the 5 rolls for model two

% 10 matrixes are filled with the multiplication of the matrixes storing the probabilities for
% each one of the values in the sequence. This is the result of the outputs
% of the forward and backwards algorithm.

posterior_even_roll_one = forward_matrix_even_roll_one .* backwards_matrix_even_roll_one;
posterior_odd_roll_one = forward_matrix_odd_roll_one .* backwards_matrix_odd_roll_one;

posterior_even_roll_two = forward_matrix_even_roll_two .* backwards_matrix_even_roll_two;
posterior_odd_roll_two = forward_matrix_odd_roll_two .* backwards_matrix_odd_roll_two;

posterior_even_roll_three = forward_matrix_even_roll_three .* backwards_matrix_even_roll_three;
posterior_odd_roll_three = forward_matrix_odd_roll_three .* backwards_matrix_odd_roll_three;

posterior_even_my_roll_one = forward_matrix_even_my_roll_one .* backwards_matrix_even_my_roll_one;
posterior_odd_my_roll_one = forward_matrix_odd_my_roll_one .* backwards_matrix_odd_my_roll_one;

posterior_even_my_roll_two = forward_matrix_even_my_roll_two .* backwards_matrix_even_my_roll_two;
posterior_odd_my_roll_two = forward_matrix_odd_my_roll_two .* backwards_matrix_odd_my_roll_two;



% the results are evaluated to check what is the most likely state to
% output the values in this sequence.
for pos = 1:100
    if posterior_even_my_roll_one(1, pos)>posterior_even_my_roll_one(2, pos)
        posterior(1, pos) = 1;
    else
        posterior(1, pos) = 2;
    end
    if posterior_even_my_roll_two(1, pos)>posterior_even_my_roll_two(2, pos)
        posterior(2, pos) = 1;
    else
        posterior(2, pos) = 2;
    end
    if posterior_even_roll_one(1, pos)>posterior_even_roll_one(2, pos)
        posterior(3, pos) = 1;
    else
        posterior(3, pos) = 2;
    end
    if posterior_even_roll_two(1, pos)>posterior_even_roll_two(2, pos)
        posterior(4, pos) = 1;
    else
        posterior(4, pos) = 2;
    end
    if posterior_even_roll_three(1, pos)>posterior_even_roll_three(2, pos)
        posterior(5, pos) = 1;
    else
        posterior(5, pos) = 2;
    end
    if posterior_odd_my_roll_one(1, pos)>posterior_odd_my_roll_one(2, pos)
        posterior(6, pos) = 1;
    else
        posterior(6, pos) = 2;
    end
    if posterior_odd_my_roll_two(1, pos)>posterior_odd_my_roll_two(2, pos)
        posterior(7, pos) = 1;
    else
        posterior(7, pos) = 2;
    end
    if posterior_odd_roll_one(1, pos)>posterior_odd_roll_one(2,pos)
        posterior(8, pos) = 1;
    else
        posterior(8, pos) = 2;
    end
    if posterior_odd_roll_two(1,pos)>posterior_odd_roll_two(2,pos)
        posterior(9, pos) = 1;
    else
        posterior(9, pos) = 2;
    end
    if posterior_odd_roll_three(1,pos)>posterior_odd_roll_three(2, pos)
        posterior(10, pos) = 1;
    else
        posterior(10, pos) = 2;
    end
end


end