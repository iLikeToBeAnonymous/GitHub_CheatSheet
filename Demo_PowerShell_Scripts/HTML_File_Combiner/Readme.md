# Quick and Dirty way of combining HTML files
## _Premise_
This PowerShell script has much room for improvement, however, it works. It makes the following assumptions:
1) HTML files are all in the same folder
2) The PS1 file is in the same folder
3) The files to be combined either do not need to be combined in a certain order or they are named in a fashion that corresponds to the desired sort order
4) All HTML content outside the `<body></body>` tags is functionally identical across all the HTML files.
