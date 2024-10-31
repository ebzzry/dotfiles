---
title: 'Emacs-reveal: A software bundle to create OER presentations'
tags:
  - slideshow
  - Open Educational Resources (OER)
  - GNU Emacs
  - reveal.js
  - Org Mode
authors:
  - name: Jens Lechtenbörger
    orcid: 0000-0002-3064-147X
    affiliation: 1
affiliations:
 - name: ERCIS, University of Münster, Germany
   index: 1
date: 4 August 2019
bibliography: paper.bib
---

# Introduction

According to the *Ljubljana OER Action Plan 2017* [@Une17], “Open
Educational Resources (OER) support quality education that is
equitable, inclusive, open and participatory.”  However, several
challenges are known that hinder widespread creation, use, and re-use
of OER.  The first challenge identified in the Action Plan lies in
“the capacity of users to find, re-use, create,and share OER”, and the
first action category addressing that challenge, “Building awareness
and skills to use OER”, lists ten actions, among which action (c)
reads as follows: “Disseminate the findings of research on OER to
support models of good practice with a focus on cost-effectiveness,
sustainability, exploration of new tools and technologies for the
creation and sharing of OER”.

Emacs-reveal is a Free/Libre and Open Source Software
(FLOSS) bundle (combining novel and established FLOSS components) in
accordance with action (c).  Briefly, emacs-reveal is a software tool,
embedded in a powerful Continuous Integration infrastructure, to
create and (re-) use OER slideshows (for courses and talks) with
references and embedded multimedia contents such as figures, audio
explanations, animations, videos, quizzes, and live code execution.
The software simplifies creation and re-use of OER by addressing
OER-specific requirements as summarized next.

# Technical requirements for OER

For educational resources to be free and open, next to proper
licensing requirements also technical requirements exist (as defined
in the ALMS framework, which was proposed by @HWSJ10 and extended by
@Lec19):

- OER should be usable (for learning) with FLOSS
  on (almost) any device, also mobile and offline.
- OER should be editable with FLOSS
  (this requires source file access).
- OER should be re-usable under the Single Sourcing paradigm
  [@Roc01], which enables reuse and revision from a single,
  consistent source without copy&paste (copy&paste creates isolated
  copies, where the reconciliation of changes and improvements by
  different individuals would be almost impossible).
- OER should offer a separation of contents from layout (then, experts
  for content do not need to be design experts as well; also,
  cross-organizational collaboration is supported where each
  organization can apply its own design guidelines).
- OER should be defined in a lightweight markup language, which is easy
  to learn and which enables the use of industrial-strength version
  control systems such as Git for the management of OER collaboration
  (comparison, revision, merge).

# Statement of Need

The author was unable to locate FLOSS for the creation of OER
presentations with audio explanations that satisfies the above
requirements, confirming the need for “new tools and technologies for
the creation and sharing of OER” identified in the Action Plan
cited above [@Une17].

For example, support for presentations created with software such as
LibreOffice Impress on mobile devices was and still is limited, as is
support for Single Sourcing and separation of contents from layout.
Beamer LaTeX presentations [see @beamer] support Single Sourcing with
separation of contents from layout, and generated PDF documents can
embed audio files, but their playback using FLOSS on mobile devices
was and still is limited.  The author did not systematically analyze
Wiki-style presentations, such as those created with SlideWiki
[@AKT13], because he was looking for support for Single Sourcing and
collaboration based on the capabilities of decentralized version
control systems such as Git [@gitbook].

# Functionality of emacs-reveal

Emacs-reveal meets all of the above requirements, which lowers entry
barriers towards a more widespread creation of OER.  As described in
@Lec19b, for OER creators it simplifies licensing attribution when
re-using figures with machine-readable meta-data based on an extension
of CC REL (The Creative Commons Rights Expression Language, see
@AAL+12), (a) avoiding manual identification and copying of
licensing information, which is among the most time-consuming factors
for OER projects [see @FLGB16], and (b) making licensing information
accessible on the Semantic Web with RDFa in HTML
[see @Hor08 for a general introduction to the Semantic Web].

With emacs-reveal, source files for presentations are written in the
lightweight markup language Org Mode [@SD11] and converted to
slideshows based on the HTML presentation framework
[reveal.js](https://revealjs.com/).
Org mode is native to the
text editor [GNU Emacs](https://www.gnu.org/software/emacs/) but can
be edited in any text editor; it is also used in other contexts
to create modular and reusable teaching materials [@org-coursepack].
[Docker images for emacs-reveal](https://gitlab.com/oer/docker)
can be used to generate OER presentations in
GitLab Continuous Integration infrastructures, notably a
[Howto presentation](https://oer.gitlab.io/emacs-reveal-howto/howto.html)
for emacs-reveal is maintained that way, as are
[presentations](https://oer.gitlab.io/OS/) for a course on Operating
Systems (based on Just-in-Time Teaching, which relies on
considerable self-study, see @jitt) for which emacs-reveal was originally
developed.

# Acknowledgements

The author acknowledges funding for a fellowship for innovation in
digital university teaching by the Ministry of Innovation, Science and
Research of the State of North Rhine-Westphalia, Germany, and
Stifterverband, Germany during the genesis of this project.

The author would like to thank the reviewers whose constructive
criticism helped to improve this paper as well as the project.

# References
