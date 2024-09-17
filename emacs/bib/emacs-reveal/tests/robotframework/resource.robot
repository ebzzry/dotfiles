# Copyright (C) 2019 Michael Pfennings
# Copyright (C) 2020 Jens Lechtenbörger
# SPDX-License-Identifier: GPL-3.0-or-later

*** Settings ***
Documentation     Reusable keywords and variables for reveal.js tests.
Library           SeleniumLibrary

*** Variables ***
${SERVER}          file:///robot/public
${BROWSER}         %{BROWSER}
${PRESENTATION}    %{PRESENTATION}
${START SLIDE}     ${SERVER}/${PRESENTATION}
${PRESENTATION TITLE}     Test presentation for emacs-reveal
${NOTES URL}              ${SERVER}/reveal.js/plugin/notes/notes.html

# Slide that allows navigation to all directions
${TEST SLIDE}             ${START SLIDE}#/slide-navigation
${TEST SLIDE NUMBER}      4

# The numbers of the following div elements depend on the presence or
# absence of a preamble.  Increase to 2 and 3 when preamble is present.
${REVEAL SELECTOR}        xpath:/html/body/div[1]
${COURSEVIEW SELECTOR}    xpath:/html/body/div[2]
${CONTROL SELECTOR}       ${REVEAL SELECTOR}/aside
${SLIDE NO SELECTOR}      xpath:(/html/body/div[1]/div[4]/a/span | /html/body/div[1]/div[3]/a/span)

*** Keywords ***

Open Browser To Start Slide
  Open Browser    ${START SLIDE}    ${BROWSER}
  Maximize Browser Window
  First Slide Should Be Open

First Slide Should Be Open
  Title Should Be   ${PRESENTATION TITLE}

Go To Test Slide
  Go To   ${TEST SLIDE}
  Slide Number Should Be    ${TEST SLIDE NUMBER}

Go One Slide Left
  Click Button  ${CONTROL SELECTOR}/button[1]

Go One Slide Right
  Click Button  ${CONTROL SELECTOR}/button[2]

Go One Slide Up
  Click Button  ${CONTROL SELECTOR}/button[3]

Go One Slide Down
  Click Button  ${CONTROL SELECTOR}/button[4]

Slide Number Should Be
  [Arguments]   ${slidenumber}
  Wait Until Element Is Visible    ${SLIDE NO SELECTOR}
  Element Should Contain           ${SLIDE NO SELECTOR}   ${slidenumber}

Go To Slide
  [Arguments]   ${slidenumber}
  Press Keys    None    ${slidenumber}
  Press Keys    None    ENTER
  Slide Number Should Be    ${slidenumber}

# Navigate to section
Press Menu Link
  [Arguments]    ${menuname}
  Click Element   ${REVEAL SELECTOR}/footer/div[1]/div/ul/li[.//text()="${menuname}"]/a

# Navigate to subsection
Press Inner Menu Link
  [Arguments]    ${menuname}
  Click Element  ${REVEAL SELECTOR}/footer/div[2]/div/ul/ul/li[.//text()="${menuname}"]/a

Go To Next Slide
  Press Keys    None    n

Go To Previous Slide
  Press Keys    None    p

Get Slide Number
  ${slidenumber}    Get Text   ${SLIDE NO SELECTOR}
  [return]    ${slidenumber}
