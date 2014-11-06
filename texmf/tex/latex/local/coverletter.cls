% v1.0 by Erich L Foster 06 November 2014
%%% IDENTIFICATION --------------------------------------------------------
\NeedsTeXFormat{LaTeX2e}[01/01/10]
\ProvidesClass{coverletter}[06/11/2014 v1.0 Cover letter class]

\def\@@ptsize{12pt}
\DeclareOption{10pt}{\def\@@ptsize{10pt}}
\DeclareOption{11pt}{\def\@@ptsize{11pt}}
\DeclareOption{12pt}{\def\@@ptsize{12pt}}

\def\@@papersize{letterpaper}
\DeclareOption{letterpaper}{\def\@@papersize{letterpaper}}
\DeclareOption{a4paper}{\def\@@papersize{a4paper}}

%%% EXECUTION OF OPTIONS --------------------------------------------------
%% default to:
\ExecuteOptions{}

\ProcessOptions

%%% PACKAGE LOADING -------------------------------------------------------
%% based on std letter class
\LoadClass[\@@ptsize,\@@papersize]{letter}

\RequirePackage{graphicx}
\RequirePackage{amsmath,amssymb}
\RequirePackage[UKenglish]{datetime}
\RequirePackage[top=0.75in, bottom=0.5in, left=0.75in, right=0.75in]{geometry}

\newcommand*{\Name}[1]{\def\@name{#1}} % Your name
\newcommand*{\Title}[1]{\def\@title{#1}} % Your title
\newcommand*{\dept}[1]{\def\@dept{#1}} % Your department/institution
\newcommand*{\Address}[1]{\def\@address{#1}} % Your address
\newcommand*{\email}[1]{\def\@email{#1}} % Your email address
\newcommand*{\phone}[1]{\def\@phone{#1}} % Your phone number
\newcommand*{\homepage}[1]{\def\@homepage{#1}} % Your URL
\newcommand*{\logo}[1]{\def\@logo{#1}} % department logo

\address{
    \includegraphics[width=1.5in]{\@logo}
    \hspace{5.1in} \\[-1.5ex]
    \makebox[\textwidth][r]{\large \bf \@name, \@title\hspace{1.0in}}\\
    \hline
    \hspace{\fill}
    \parbox[t]{3in}{
        \@dept \\ % Your department
        \@address\\ % Your address
        phone: \@phone\\ % Your phone number
        email: \@email\\ % Your email address
        homepage: \@homepage % Your URL
    }
}

\newcommand{\savefootnote}[2]{\footnote{\label{#1}#2}}
\newcommand{\repeatfootnote}[1]{\textsuperscript{\ref{#1}}}

\newdateformat{mydate}{\twodigit{\THEDAY}~\monthname[\THEMONTH] \THEYEAR}
\date{\mydate\today}

\signature{\@name, \@title}
