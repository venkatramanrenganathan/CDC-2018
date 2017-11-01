function [ output_args ] = naive_bayes_classifier( i, agents_signal_fingerprints )
% naive_bayes_classifier function classifies test data with respect to
% training data using bayesian probability.

    agents_signal_fingerprints(i,:) = [];
    mean_alpha_legit = mean(agents_signal_fingerprints(1:end-2,1));
    mean_alpha_mal = mean(agents_signal_fingerprints(end-1:end,1));
    mean_ref_alfa_legit = mean(agents_signal_fingerprints(1:end-2,2));
    mean_ref_alfa_mal = mean(agents_signal_fingerprints(end-1:end,2));
    mean_amp1_legit = mean(agents_signal_fingerprints(1:end-2,3));
    mean_amp1_mal = mean(agents_signal_fingerprints(end-1:end,3));
    mean_amp2_legit = mean(agents_signal_fingerprints(1:end-2,4));
    mean_amp2_mal = mean(agents_signal_fingerprints(end-1:end,4));
    mean_time_legit = mean(agents_signal_fingerprints(1:end-2,5));
    mean_time_mal = mean(agents_signal_fingerprints(end-1:end,5));
    
    std_alpha_legit = std(agents_signal_fingerprints(1:end-2,1));
    std_alpha_mal = std(agents_signal_fingerprints(end-1:end,1));
    std_ref_alfa_legit = std(agents_signal_fingerprints(1:end-2,2));
    std_ref_alfa_mal = std(agents_signal_fingerprints(end-1:end,2));
    std_amp1_legit = std(agents_signal_fingerprints(1:end-2,3));
    std_amp1_mal = std(agents_signal_fingerprints(end-1:end,3));
    std_amp2_legit = std(agents_signal_fingerprints(1:end-2,4));
    std_amp2_mal = std(agents_signal_fingerprints(end-1:end,4));
    std_time_legit = std(agents_signal_fingerprints(1:end-2,5));
    std_time_mal = std(agents_signal_fingerprints(end-1:end,5));
    
    %x = (agents_signal_fingerprints(end-1,:) + agents_signal_fingerprints(end,:) ) / 2;
    x = agents_signal_fingerprints(1,:);
    
    alfa_leg = pdf(makedist('Normal',mean_alpha_legit,std_alpha_legit), x(1));
    alfa_mal = pdf(makedist('Normal',mean_alpha_mal,std_alpha_mal), x(1));
    ref_alfa_leg = pdf(makedist('Normal',mean_ref_alfa_legit,std_ref_alfa_legit), x(2));
    ref_alfa_mal = pdf(makedist('Normal',mean_ref_alfa_mal,std_ref_alfa_mal), x(2));
    amp1_leg = pdf(makedist('Normal',mean_amp1_legit,std_amp1_legit), x(3));
    amp1_mal = pdf(makedist('Normal',mean_amp1_mal,std_amp1_mal), x(3));
    amp2_leg = pdf(makedist('Normal',mean_amp2_legit,std_amp2_legit), x(4));
    amp2_mal = pdf(makedist('Normal',mean_amp2_mal,std_amp2_mal), x(4));
    time_leg = pdf(makedist('Normal',mean_time_legit,std_time_legit), x(5));
    time_mal = pdf(makedist('Normal',mean_time_mal,std_time_mal), x(5));
    
    leg_post = 0.5*alfa_leg*ref_alfa_leg*amp1_leg*amp2_leg*time_leg;
    mal_post = 0.5*alfa_mal*ref_alfa_mal*amp1_mal*amp2_mal*time_mal;
    evidence = leg_post + mal_post;
    legit_prob = leg_post/evidence;
    mal_prob = mal_post/evidence;
    if(legit_prob > mal_prob)
        display('Legitimate Robot');
    else
        display('Spoofed Robot');
    end
end

