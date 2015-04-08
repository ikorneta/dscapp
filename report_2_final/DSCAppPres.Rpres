The DS-CApp: The Spring 2015 Coursera Data Science Capstone App
========================================================
author: Iga Korneta
date: April 2015
transition: concave
font-family: 'Myriad'


Slide 2
========================================================
title: Task
transition: concave

**Task:**

* Take the HC Corpora data corpus used throughout the Capstone

* Create a Shiny app that accepts an n-gram as input and predicts the next word       
         


Slide 3
========================================================
title: Algorithm
transition: concave

**Algorithm**:
* sequential look-up in precomputed n-gram tables (4-, 3- and 2-grams)
* only results with the 4 highest term frequencies stored per n-gram prefix (fast look-up)
* results reweighted for saliency by n-gram level (0.47 if 4-gram, 0.31 if 3-gram, 0.21 if 2-gram) - results found in lower n-gram-level tables treated as less salient
* if no result found in the tables, the word "that" is proposed (a popular conjunction)



Slide 4
========================================================
title: App
transition: concave

**How to use the app:**
![main app window](./DSCAppPres-figure/main.png)



Slide 5
========================================================
title: Contact
transition: concave
left:15%

**Where to get it and associated files:**
* ShinyApp Server: http://ikorneta.shinyapps.io/dscapp
* Code and documentation: http://github.com/ikorneta/dscapp
* Milestone Report (contains description of the corpus): http://rpubs.com/ikorneta/dscapstone03
* This slide deck: http://rpubs.com/ikorneta/dscapp
