// SPDX-FileCopyrightText: 2018-2019 Jens Lechtenbörger
// SPDX-License-Identifier: CC-BY-SA-4.0
// Copied from emacs-reveal-howto

quiz = {
    "info": {
        "name":    "", // Should be empty with emacs-reveal
        "main":    "What do you know about emacs-reveal?  Let's see...",
        "level1":  "Excellent!", // 80-100%
        "level2":  "Well done!", // 60-79%
        "level3":  "You may need to re-read some parts.", // 40-59%
        "level4":  "Did you just jump here?",             // 20-39%
        "level5":  "Please restart from the beginning."   // 0-19%, no comma here
    },
    "questions": [
        { // Question 1 - Multiple Choice, Single True Answer
            "q": "Which statement about emacs-reveal is correct?",
            "a": [
                {"option": "Emacs-reveal is part of GNU Emacs", "correct": false},
                {"option": "Emacs-reveal is free/libre and open source software", "correct": true},
                {"option": "Emacs-reveal is written in HTML5", "correct": false},
                {"option": "Emacs-reveal is written in JavaScript", "correct": false} // no comma here
            ],
            "correct": "<p><span>Correct!</span> Yes, emacs-reveal respects your freedom and is useful even if you know neither HTML nor JavaScript!</p>",
            "incorrect": "<p><span>No.</span> You may want to start over.</p>" // no comma here
        },
        { // Question 2 - Multiple Choice, Multiple True Answers, Select All
            "q": "What is good about emacs-reveal? (Select ALL.)",
            "a": [
                {"option": "Useful to produce Open Education Resources (OER)", "correct": true},
                {"option": "Uses simple text format for ease of collaboration", "correct": true},
                {"option": "Uses simple syntax to embed OER figures with proper attribution", "correct": true},
                {"option": "Embeds useful plugins by default (e.g., audio, quizzes)", "correct": true},
                {"option": "Generates platform-independent HTML presentations", "correct": true},
                {"option": "Generated presentations can be used offline", "correct": true} // no comma here
            ],
            "correct": "<p><span>Correct!</span> You got it all.</p>",
            "incorrect": "<p><span>Not Quite.</span> Try again.</p>" // no comma here
        } // no comma here
    ]
};
