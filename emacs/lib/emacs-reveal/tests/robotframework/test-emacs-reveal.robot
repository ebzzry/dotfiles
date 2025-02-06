# Copyright (C) 2019 Michael Pfennings
# Copyright (C) 2020 Jens Lechtenbörger
# SPDX-License-Identifier: GPL-3.0-or-later

*** Settings ***
Suite Setup       Open Browser To Start Slide
Suite Teardown    Close Browser
Test Setup        Go To Test Slide
Resource          resource.robot

*** Variables ***
${NOTES SLIDE NUMBER}    5
${QUIZ SLIDE NUMBER}     6

*** Test Cases ***
Initialization
  Log To Console    Testing ${BROWSER} on ${PRESENTATION}
  Go To Test Slide

Menu Links
  Press Menu Link           Main Part
  Slide Number Should Be    3
  Press Inner Menu Link     A slide with speaker notes
  Slide Number Should Be    ${NOTES SLIDE NUMBER}

Slide Changing
  Go To Slide    ${NOTES SLIDE NUMBER}

Next Slide Shortcut
  Slide Number Should Be    ${TEST SLIDE NUMBER}
  Go To Next Slide
  ${newslide}    Get Slide Number
  Should Not Be Equal As Integers    ${TEST SLIDE NUMBER}    ${newslide}
  Go To Previous Slide
  Slide Number Should Be    ${TEST SLIDE NUMBER}

Previous Slide Shortcut
  Slide Number Should Be    ${TEST SLIDE NUMBER}
  Go To Previous Slide
  ${newslide}    Get Slide Number
  Should Not Be Equal As Integers    ${TEST SLIDE NUMBER}    ${newslide}
  Go To Next Slide
  Slide Number Should Be    ${TEST SLIDE NUMBER}

Navigation Button Up
  Slide Number Should Be    ${TEST SLIDE NUMBER}
  Go One Slide Up
  ${newslide}    Get Slide Number
  Should Not Be Equal As Integers    ${TEST SLIDE NUMBER}    ${newslide}
  Go One Slide Down
  Slide Number Should Be    ${TEST SLIDE NUMBER}

Navigation Button Down
  Slide Number Should Be    ${TEST SLIDE NUMBER}
  Go One Slide Down
  ${newslide}    Get Slide Number
  Should Not Be Equal As Integers    ${TEST SLIDE NUMBER}    ${newslide}
  Go One Slide Up
  Slide Number Should Be    ${TEST SLIDE NUMBER}

Navigation Button Left
  Slide Number Should Be    ${TEST SLIDE NUMBER}
  Go One Slide Left
  ${newslide}    Get Slide Number
  Should Not Be Equal As Integers    ${TEST SLIDE NUMBER}    ${newslide}
  Go One Slide Right
  Slide Number Should Be    ${TEST SLIDE NUMBER}

Navigation Button Right
  Slide Number Should Be    ${TEST SLIDE NUMBER}
  Go One Slide Right
  ${newslide}    Get Slide Number
  Should Not Be Equal As Integers    ${TEST SLIDE NUMBER}    ${newslide}
  Go One Slide Left
  Slide Number Should Be    ${TEST SLIDE NUMBER}

Menu Links And Slide Changing
  Press Menu Link   Main Part
  Slide Number Should Be    3
  Go To Slide   5

# With scaling of reveal.js enabled, Chrome does not target the proper elements.
Check Quiz Click
  Pass Execution If    '${BROWSER}' == 'chrome'    Skipped click test with Chrome.
  Go To Slide    ${QUIZ SLIDE NUMBER}
  Wait Until Element Is Visible    xpath://*[@id="slickQuiz-0_question0_1"]
# Choose option.
  Click Element                    xpath://*[@id="slickQuiz-0_question0_1"]
# Check answer.
  Click Element                    xpath://*[@id="question0"]/a[3]
  Wait Until Element Is Visible    //*[@id="question0"]/ul[2]/li[1]/p
  Element Should Contain           //*[@id="question0"]/ul[2]/li[1]/p    Correct!
  Element Should Contain           //*[@id="question0"]/ul[2]/li[2]/p    ${EMPTY}
# Go to next question, wait for it.
  Click Element                    xpath://*[@id="question0"]/a[2]
  Wait Until Element Is Visible    xpath://*[@id="question1"]/ul[1]/li[2]/label
# Choose options
  Click Element                    xpath://*[@id="question1"]/ul[1]/li[2]/label
  Click Element                    xpath://*[@id="question1"]/ul[1]/li[3]/label
  Click Element                    xpath://*[@id="question1"]/ul[1]/li[4]/label
# Check answer.
  Click Element                    xpath://*[@id="question1"]/a[3]
  Element Should Contain           //*[@id="question1"]/ul[2]/li[2]/p    Not Quite.
# Follow "Next" link.
  Click Element                    xpath://*[@id="question1"]/a[2]
# Wait for "Retry" link and follow it.
  Wait Until Element Is Visible    xpath://*[@id="slickQuiz-0"]/div[2]/div/p[1]/a
  Click Element                    xpath://*[@id="slickQuiz-0"]/div[2]/div/p[1]/a
  Wait Until Element Is Visible    xpath://*[@id="slickQuiz-0_question0_1"]

Courseware View
  Go To Slide    ${NOTES SLIDE NUMBER}
  Press Keys    None    v
  Element Should Be Visible   ${COURSEVIEW SELECTOR}
  Press Keys    None    v
  Element Should Not Be Visible   ${COURSEVIEW SELECTOR}

# With chrome and reveal.js 4, the following tests hangs.
# No idea, why.
Speaker Notes
  Pass Execution If    '${BROWSER}' == 'chrome'    Skipped speaker notes with Chrome.
  Go To Slide    ${NOTES SLIDE NUMBER}
  Press Keys    None    s
  Select Window    NEW
  Element Should Be Visible   xpath://*[@id="speaker-controls"]
