% RESUME DOCUMENT STYLE -- Released 23 Nov 1989
%    for LaTeX version 2.09
% Copyright (C) 1988,1989 by Michael DeCorte
%heavily modified by Erich L Foster 2014

\typeout{Document Style `CV' <29 Aug 2014>.}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CV.sty
%
% \documentstyle{CV}
%
% Copyright (c) 1988 by Michael DeCorte
% Copyright (c) 2014 by Erich L Foster
% Permission to copy all or part of this work is granted, provided
% that the copies are not made or distributed for resale, and that
% the copyright notice and this notice are retained.
%
% THIS WORK IS PROVIDED ON AN "AS IS" BASIS.  THE AUTHOR PROVIDES NO
% WARRANTY WHATSOEVER, EITHER EXPRESS OR IMPLIED, REGARDING THE WORK,
% INCLUDING WARRANTIES WITH RESPECT TO ITS MERCHANTABILITY OR FITNESS
% FOR ANY PARTICULAR PURPOSE.
%
% If you make any improvements, I'd like to hear about them.
%
% Michael DeCorte
% P.O. Box 652
% Potsdam NY 13676
% mrd@sun.soe.clarkson.edu
% mrd@clutx.bitnet
%
% Changes for LaTeX2e -- Venkat Krishnamurthy (Aug 7, 2001)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% You can have multiple style options the legal options ones are:
%
%   centered    the name and address are centered at the top of the
%       page (default)
%
%   line    the name is the left with a horizontal line then
%       the address to the right
%
%   overlapped  the section titles overlap the body text (default)
%
%   margin  the section titles are to the left of the body text
%
%   11pt    use 11 point fonts instead of 10 point fonts
%
%   12pt    use 12 point fonts instead of 10 point fonts
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Commands
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   \Resume prints the word CV but typeset nicely
%
%   \name{text} defines your name
%
%   \address{text}
%       defines your address
%       this can be called twice if you have two addresses
%       use \\'s to indicate where either line breaks or
%       comas should go
%
%   \opening    this prints your name and address at that spot
%       this is not normally needed, as \begin{CV}
%       does this but is provided just in case you need
%       to do something odd
%
%   \begin{CV} ... \end{CV}
%       all of the CV should go inside of this
%       environment
%
%   \section{text}
%       This prints 'text' in the left hand margin.
%       Its exact placement depends on what the style
%       options has been set to. (overlapped or margin)
%       You should use \\ to start a new line.  If the
%       style option is margin, the \\ is converted
%       to a space.
%       To use this in any of the list environments, put
%       the \section after the \item[] but before the
%       text.
%       Eg.
%       \begin{itemize}
%       \item\section{text}
%       text
%       \end{itemize}
%
%   \begin{ncolumn}{n} ... \end{ncolumn}
%       creates a tabular environment with n equally
%       spaced columns.  Separate columns by & and
%       end them with \\
%
%   \begin{duties} ... \end{duties}
%       this is used to print a job description.  There should
%       be only one job description in it.  Information
%       related to the job (such as title, dates...) will
%       be printed.
%
%   \begin{format} ... \end{format}
%       used to change the default format for the position
%       environment.  Within it the recognized commands are:
%       \position{option}
%       \employer{option}
%       \location{option}
%       \dates{option}
%       \body
%       \\
%       where option is one of l,r,c standing for left, right, center.
%       The format will eventually be used to make several
%       tabular environments and you are defining the number of columns
%       and the placement of text within the columns of the tabulars.
%       Each row is terminated by a \\.  Any number of options can
%       be on a line, they will each be set in their own columns.
%       Any of the options except \body may be left out.
%
%       Eg.
%       \begin{format}
%       \position{l}\employer{r}\\
%       \dates{r}\\
%       \body\\
%       \location{l}\\
%       \end{format}
%
%       In this example the title and employer information
%       are set in 2 columns left justified and right justified
%       respectively.  Then the date is set right justified.
%       Then the body is set.  Then the location is set left
%       justified.
%
% \employer{text}
% \position{text}
% \dates{text}
% \location{text}
%       declare text for the next invocation of the position
%       environment
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Glue
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% sectionskip   the amount of horizontal before a section
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dimensions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% sectionwidth  the amount that the section titles go in the
%       left margin
%
% CVwidth   the width of the total CV from the left
%       margin to the right.  Don't use textwidth
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Definitions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% sectionfont   the font used to print section titles
%       use \renewcommand to change it
%
% namefont  the font used to print your name
%       use \renewcommand to change it
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% THINGS TO DO
%
% add lm,rm options to format style to allow things to be placed
% in the left or right margin respectivly
%
% add capability so that \body doesn't have to be proceeded (followed)
% by a \\ allowing part of the description (eg. location) to be the
% first (last) thing of the body
%
% clean up the list building procedures
%
% write docs to tell people how to use this

\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{CV}[2000/05/19 v1.4b Resume class]

%\DeclareOption{11pt}{\renewcommand\@ptsize{1}}
%\DeclareOption{12pt}{\renewcommand\@ptsize{2}}

\PassOptionsToClass{11pt,12pt}{article}
\LoadClassWithOptions{article}

\RequirePackage{etaremune}
% stack of key-value elements, used to save personal information
\RequirePackage{fancyhdr}
\RequirePackage{ifthen}
\RequirePackage{etoolbox}
\RequirePackage{float}
\RequirePackage[normalem]{ulem}
\RequirePackage{enumerate,paralist}
\RequirePackage{graphicx}
\RequirePackage{epsfig}
\RequirePackage{caption,subcaption}
\RequirePackage{titlesec}
\RequirePackage{hyperref}
\RequirePackage{multirow,multicol}
\RequirePackage{geometry}
\RequirePackage[backend=bibtex,dateabbrev=false,firstinits=true,isbn=false,url=true,doi=true,defernumbers=true,style=numeric,sorting=ydnt]{biblatex}
\RequirePackage{xpatch}% or use http://tex.stackexchange.com/a/40705
\numdef\blx@maxbibnames{99}

%only use url if doi doesn't exist
\renewbibmacro*{doi+eprint+url}{%
  \iftoggle{bbx:doi}
    {\printfield{doi}}
    {}%
  \newunit\newblock
  \iftoggle{bbx:eprint}
    {\usebibmacro{eprint}}
    {}%
  \newunit\newblock
  \iftoggle{bbx:url}
    {\iffieldundef{doi}{\printfield{url}}{}}
    {}}

%the following will allow for the bold name authors in biblatex
\newbibmacro*{name:bold}[2]{%
  \def\do##1{\ifstrequal{#1, #2}{##1}{\bfseries\listbreak}{}}%
  \dolistloop{\boldnames}}
\newcommand*{\boldnames}{}

\xpretobibmacro{name:last}{\begingroup\usebibmacro{name:bold}{#1}{#2}}{}{}
\xpretobibmacro{name:first-last}{\begingroup\usebibmacro{name:bold}{#1}{#2}}{}{}
\xpretobibmacro{name:last-first}{\begingroup\usebibmacro{name:bold}{#1}{#2}}{}{}
\xpretobibmacro{name:delim}{\begingroup\normalfont}{}{}

\xapptobibmacro{name:last}{\endgroup}{}{}
\xapptobibmacro{name:first-last}{\endgroup}{}{}
\xapptobibmacro{name:last-first}{\endgroup}{}{}
\xapptobibmacro{name:delim}{\endgroup}{}{}

% default bibliography environment (from biblatex.sty)
\defbibenvironment{bibliography}
  {\list{}{%
     \leftmargin\bibhang
     \itemindent-\leftmargin
     \itemsep\bibitemsep
      \parsep\bibparsep}}
  {\endlist}
  {\item}

% 'numeric' bibliography environment (from numeric.bbx)
\defbibenvironment{bibliography}
  {\list
     {\printtext[labelnumberwidth]{%
        \printfield{prefixnumber}%
        \printfield{labelnumber}}}
     {\setlength{\labelwidth}{\labelnumberwidth}%
      \setlength{\leftmargin}{\labelwidth}%
      \setlength{\labelsep}{\biblabelsep}%
%      \addtolength{\leftmargin}{\labelsep}%
      \addtolength{\leftmargin}{9ex}% <-- changed
      \setlength{\itemsep}{\bibitemsep}%
      \setlength{\parsep}{\bibparsep}}%
      \renewcommand*{\makelabel}[1]{\hss##1}}
  {\endlist}
  {\item}

%how to format the header
\newif\if@line
\newif\if@centered
\newif\if@margin
\newif\if@footer

\DeclareOption{a4paper}
   {\setlength\paperheight {297mm}%
    \setlength\paperwidth  {210mm}}

\DeclareOption{letterpaper}
   {\setlength\paperheight {11in}%
    \setlength\paperwidth  {8.5in}}

\DeclareOption{line}{\@linetrue}
\DeclareOption{noline}{\@linefalse}
\DeclareOption{centered}{\@centeredtrue}
\DeclareOption{flush}{\@centeredfalse}
\DeclareOption{footer}{\@footertrue}
\DeclareOption{nofooter}{\@footerfalse}

\DeclareOption{margin}{\@margintrue}
\DeclareOption{overlapped}{\@marginfalse}

\ExecuteOptions{overlapped,centered,line,footer}
\ProcessOptions\relax

%define case for article and book
\DeclareFieldFormat[article]{titlecase}{\MakeSentenceCase{#1}}
\DeclareFieldFormat[book]{titlecase}{#1}

%define macros for the bibliography
\renewbibmacro*{volume+number+eid}{%
  \printfield{volume}%
  \printfield{number}%
  \setunit{\addcomma\space}%
  \printfield{eid}}
\DeclareFieldFormat[article]{number}{\mkbibparens{#1}}

%count in reverse using prefix number
\AtDataInput{%
  \csnumgdef{entrycount:\strfield{prefixnumber}}{%
    \csuse{entrycount:\strfield{prefixnumber}}+1}}

\DeclareFieldFormat{labelnumber}{\mkbibdesc{#1}}
\newrobustcmd*{\mkbibdesc}[1]{%
  \number\numexpr\csuse{entrycount:\strfield{prefixnumber}}+1-#1\relax}

\defbibheading{section}{\section{#1}\vspace{1.5em}}
\defbibheading{subsection}{\subsection{#1}\vspace{1.5em}}
\renewbibmacro{in:}{}
%need more space before the bib titles
%\pretocmd{\printbibliography}{\bigskip}{}{}

%\nofiles        % CV's don't need .aux files


\newtoks\tabular@text           % holds the current list being processed
\newtoks\tabular@head           % holds the head tabular list
\newtoks\tabular@tail           % holds the tail tabular list
\newtoks\@ta                % used by \@append
\newtoks\undefined@token\undefined@token={}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% prints a centered name with the address centered
% or the two address on opposite sides of the page
%
\def\@printcentername{\begingroup
  \ds@addresstwo
  % print the name centered
    \leavevmode\hbox to \textwidth{\hfil\@tablebox{\namefont\@name}\hfil}\par
    \if@line
        \vskip 2pt
        \fullline
        \vskip 2pt
    \fi
    \ifdefempty{\@addressone}{%
      % do nothing or print addresstwo
        \@ifundefined{@addresstwo}{ }{
            \leavevmode\hbox to \textwidth{\hfil\@tablebox{\@addresstwo}\hfil}\par
        }
    }{%
        \@ifundefined{@addresstwo}{ % only one address
            \leavevmode\hbox to \textwidth{\hfil\@tablebox{\@addressone}\hfil}\par
        }{ % two addresses
            \leavevmode\hbox to \textwidth{\@tablebox{\@addressone}\hfil
                     \@tablebox{\@addresstwo}}\par
        }%
    }%
\endgroup}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this is used to print the name and address at the top of
% the page with a hline in between
%
\def\namefont{\huge\bf}
\def\@flushname{\begingroup
  \ds@addresstwo
  \def\\{, }
  {\namefont\@name}
  \if@line
    \vskip 2pt
    \fullline
    \vskip 2pt
  \fi
  % where do you live?
  \@ifundefined{@addressone}{%
    % do nothing
  }{%
    \leavevmode\hbox to \textwidth
      {\hfill\vbox{\hbox{\@addressone}
           \hbox{\@addresstwo}
          }%
      }\par
  }
\endgroup}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HEADINGS:
% There are two types of headings:
% 1) one with the name centered and the address centered or
%    in the left and right side if there are two address
% 2) one where the name is in the upper left corner
%    the a line accross the paper
%    then the address all on one line in the right corner
%    the second address will be directly below the first if defined
%
\let\print@name\relax
\def\ds@centered{
    \ifx
        \print@name\relax\let\print@name\@printcentername
    \fi
}
\def\ds@flush{
    \ifx
        \print@name\relax\let\print@name\@flushname
    \fi
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEFAULTS: (some of them)
%
% centered name
% overlapped section titles
%
% format is:
%    position    employer
%    location    dates
%    body
% with everything in the left of its column

%\input article.sty

\if@centered
    \ds@centered
\else
    \ds@flush
\fi
\if@margin
    \ds@margin
\else
    \ds@overlapped
\fi


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% typeset CV all nice and pretty
%
\def\Resume{{R\'{e}sum\'{e}}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% makes a line of width \textwidth starting at -\hoffset
%
\def\fullline{      % hrules only listen to \hoffset
  \nointerlineskip  % so I have this code
  \moveleft\hoffset\vbox{\hrule width\textwidth}
  \nointerlineskip
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create a multiline box.
%
\def\@tablebox#1{\begin{tabular}[t]{@{}l@{\extracolsep{\fill}}}#1\end{tabular}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% use this to define your name
%
\def\name#1{\def\@name{#1}}
\def\@name{}

% defines one's phone (optional)
% usage: \phone{<phone number>}
\newcommand*{\phone}[1]{\def\@phone{#1}}

% defines one's email (optional)
% usage: \email{<email adress>}
\newcommand*{\email}[1]{\def\@email{#1}}

% defines one's home page (optional)
% usage: \homepage{<url>}
\newcommand*{\homepage}[1]{\def\@homepage{#1}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% use this to define your address, this may be called more than once.
%
\let\@addressone\relax
\let\@addresstwo\relax

%\def\address#1{
%  \@ifundefined{@addressone}{\def\@addressone{#1}}{\def\@addresstwo{#1}}}

\def\address#1{\def\@addressone{#1}}

\def\ds@addresstwo{
    \ifthenelse{\isundefined{\@phone}}{
        \ifthenelse{\isundefined{\@email}}{
            \ifthenelse{\isundefined{\@homepage}}{
            }{
                \def\@addresstwo{
                  homepage: \@homepage
                }
            }
        }{
            \ifthenelse{\isundefined{\@homepage}}{
                \def\@addresstwo{
                  email: \@email
                }
            }{
                \def\@addresstwo{
                  email: \hfill \@email\\
                  homepage: \hfill \@homepage
                }
            }
        }
    }{
        \ifthenelse{\isundefined{\@email}}{
            \ifthenelse{\isundefined{\@homepage}}{
                \def\@addresstwo{
                  phone: \@phone
                }
            }{
                \def\@addresstwo{
                  phone: \hfill \@phone\\
                  homepage: \hfill \@homepage
                }
            }
        }{
            \ifthenelse{\isundefined{\@homepage}}{
                \def\@addresstwo{
                  phone:\hfill \@phone\\
                  email:\hfill \@email
                }
            }{
                \def\@addresstwo{
                  phone:\hfill \@phone\\
                  email:\hfill \@email\\
                  homepage:\hfill \@homepage
                }
            }
        }
    }
}

%define the header and footer
\AtEndPreamble{%
    \AtBeginDocument{%
        \if@footer
            \@ifundefined{r@lastpage}{}{%
                \ifthenelse{\pageref{lastpage}>1}{%
                    \fancypagestyle{plane}{%
                        \lhead{}
                        \chead{}
                        \rhead{}
                        \lfoot{\emph{\@name}}
                        \cfoot{
                          \ifthenelse{\isundefined{\@homepage}}{}{
                            \@homepage
                          }
                        }
                        \rfoot{Page \thepage}
                        \renewcommand{\headrulewidth}{0pt}
                    }
                    \pagestyle{plane}
                }{}
            }
        \else
            \pagestyle{empty}
        \fi
        \AtEndDocument{\label{lastpage}}
    }
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if you want to print your name and address in a slightly
% different format than suggested, then this can be used
% to place it exactly where you want
%
\def\opening{\def\@opening{}
  \begingroup
  \leftskip=-\hoffset        % I use leftskip to move things to the left as
  \advance\textwidth\hoffset % changing hoffset doesn't work. But this
  \hsize=\textwidth      % doesn't really work as hboxes are rules
                 % are unaffeted
  \let\par=\@@par
  \parindent=0pt
  \parskip=0pt
  \print@name
  \endgroup
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% all of the CV goes in the CV environment
%
\newenvironment{CV}{\begingroup
  \@ifundefined{@opening}{\opening}{}
  \thispagestyle{empty}
}{\endgroup}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% gives you a tabular environment with n equally spaced columns
% \begin{ncolumn}{#} ... \end{ncolumn}
%
% The p option of LaTeX is broken in all but the newest verion
% of latex.tex, this is how to fix it
%
\def\@endpbox{\par\egroup\hfil}
\let\@@endpbox=\@endpbox

\newdimen\@columnwidth    % the width of each column equal to
\def\ncolumn#1{%
  % \@columnwidth = \textwidth / #1
  \@columnwidth=0.94\textwidth \divide\@columnwidth by #1
  \begin{tabular*}{0.94\textwidth}[t]%
    {*{#1}{@{}p{\@columnwidth}@{\extracolsep{\fill}}}}
}

\def\endncolumn{\end{tabular*}}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   \employer{text} defines employer to be text
%   \location{text} defines location to be text
%   \dates{text}    defines dates    to be text
%   \position{text}    defines position to be text
%   \body
%

\def\employer#1{\def\@employer{\bf\print@employer{#1}}}
\def\location#1{\def\@location{\print@location{#1}}}
\def\dates#1{\def\@dates{\bf\print@dates{#1}}}
\def\position#1{\def\@position{\emph{\print@position{#1}}}}
\def\student#1{\def\@student{\bf{\print@student{#1}}}}
\newcommand{\course}[2][]{
    \def\@course{\print@course{
        \textbf{#2}\ifthenelse{ \equal{#1}{} }{}{ (#1)}
    }}
}
\newcommand{\institute}[1]{\def\@institute{\print@institute{#1}}}
\newcommand{\degree}[1]{\def\@degree{\print@degree{\bf{#1}}}}
\newcommand{\award}[1]{
  \def\@award{\print@award{\bf{#1}}}
  \begin{duties}\end{duties}
}
\newcommand{\semesters}[1]{\dates{#1}}
\newcommand{\topic}[1]{\def\@topic{\print@topic{Thesis Topic: ``#1''}}}
\newcommand{\advisor}[1]{\def\@advisor{\print@advisor{Advisor: #1}}}
\newcommand{\type}[1]{\begin{duties}#1\end{duties}}
\newenvironment{studies}{\begin{duties}}{\end{duties}}
\newenvironment{descriptor}{\begin{duties}}{\end{duties}}

\let\l@justify\raggedright
\let\r@justify\raggedleft
\let\c@justify\centering


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \@format{name}{justify}
% will define \print@#1 to print it's one argument
% justified according to #2 which can be
%     l = left
%     r = right
%     c = center
%
% eg.
%    \@format{employer}{c}
%    is the same as \def\print@employer#1{{\centering #1\par}}
%
\def\@format#1#2{%
  \expandafter\gdef\csname print@#1\endcsname##1{%
    {\csname#2@justify\endcsname##1\par}}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this is used to define how the position environment should
% formated.
%
% \begin{format} positioning text \end{format}
% where positioning text may be
%  \employer{pos}
%  \location{pos}
%  \dates{pos}
%  \position{pos}
%  \body        (for the body of the position environment)
%   where pos is
%     l for left
%     r for right
%     c for center
% use \\ to break the line
% you don't have to use all of the options.
% on any one line, you should indicate what you want on that line
% and where it should go within its column.
% eg.
% the following prints the employer in the left with the location
% centered within that its column.  It then prints the date on the
% right.  Then it prints the body of the position environment. Then
% it prints the title centered within its column; as there is only
% one column here it is really just centered.
%
% \begin{format}
% \employer{l}\location{c}\\
% \dates{r}\\
% \body\\
% \position{c}\\
% \end{format}

\newcounter{numberofcolumns}
\newenvironment{format}{%
  \def\end@line@head{\append@tabular@head{tabular@text}\tabular@text={}%
    \c@numberofcolumns 0}
  \def\end@line@tail{\append@tabular@tail{tabular@text}\tabular@text={}%
    \c@numberofcolumns 0}
  \tabular@text={}
  \tabular@head={}
  \tabular@tail={}
  \c@numberofcolumns 0
  \let\\=\end@line@head
  \def\employer##1{\advance\c@numberofcolumns 1
        \@format{employer}{##1}
        \append@tabular@text{employer}}
  \def\institute##1{\advance\c@numberofcolumns 1
        \@format{institute}{##1}
        \append@tabular@text{institute}}
  \def\location##1{\advance\c@numberofcolumns 1
        \@format{location}{##1}
        \append@tabular@text{location}}
  \def\dates##1{\advance\c@numberofcolumns 1
        \@format{dates}{##1}
        \append@tabular@text{dates}}
  \def\position##1{\advance\c@numberofcolumns 1
        \@format{position}{##1}
        \append@tabular@text{position}}
  \def\course##1{\advance\c@numberofcolumns 1
        \@format{course}{##1}
        \append@tabular@text{course}}
  \def\degree##1{\advance\c@numberofcolumns 1
        \@format{degree}{##1}
        \append@tabular@text{degree}}
  \def\award##1{\advance\c@numberofcolumns 1
        \@format{award}{##1}
        \append@tabular@text{award}}
  \def\advisor##1{\advance\c@numberofcolumns 1
        \@format{advisor}{##1}
        \append@tabular@text{advisor}}
  \def\topic##1{\advance\c@numberofcolumns 1
        \@format{topic}{##1}
        \append@tabular@text{topic}}
  \def\student##1{\advance\c@numberofcolumns 1
        \@format{student}{##1}
        \append@tabular@text{student}}
  \def\body{\iftoks\tabular@head\undefined@token\then
        \else
          \@append{\noexpand\\}\to\tabular@head
        \skotfi
        \let\\=\end@line@tail}}{}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%taken from page 378 of TeXbook but freely hacked
%
% appends the expansion of #1 to the token list #2

\def\@append#1\to#2{%
  \@ta=\expandafter{#1}%
  \xdef\@append@temp{\the#2\the\@ta}
  \global#2=\expandafter{\@append@temp}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHAA006%vaxb.rhbnc.ac.uk@NSS.Cs.Ucl.AC.UK
% texhax.88.078
% is used to see if two token lists are equal
% there must be a better way
%

\let \then = \empty
\def \iftoks #1#2\then #3\else #4\skotfi{
        \edef \1{\the #1}
        \edef \2{\the #2}
        \ifx \1\2\then #3\else #4\fi}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \append@tabular@text{command}
%
% appends command to the end of \tabular@text.
% NOTE: command MUST be a command but without the \
%   Eg. \append@tabular@text{relax}
%
% used to define \tabular@text for the tabular environment
% used by append@tabular@head and append@tabular@tail
%

\def\append@tabular@text#1{%
\iftoks\tabular@text\undefined@token\then
  \global\tabular@text=\expandafter{\csname @#1\endcsname}
\else
  \@append{&}\to\tabular@text
  \@append{\csname @#1\endcsname}\to\tabular@text
\skotfi
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% append@tabular@head
%
% appends command to the end of \tabular@text@head
% NOTE: command MUST be a command but without the \
%   Eg. \append@tabular@head{relax}
%
% used to define \tabular@head for the tabular environment
% used by the position environment
%
\def\append@tabular@head#1{%
  \ifnum\the\c@numberofcolumns=0\relax
  \else
    \iftoks\tabular@head\undefined@token\then
      \relax
    \else
      \@append{\noexpand\\}\to\tabular@head
      \@append{\noexpand\penalty-\@secpenalty}\to\tabular@head
    \skotfi
    \@append{\noexpand\begin{ncolumn}}\to\tabular@head
    \@append{\expandafter{\the\c@numberofcolumns}}\to\tabular@head
    \@append{\the\csname#1\endcsname}\to\tabular@head
    \@append{\noexpand\end{ncolumn}}\to\tabular@head
  \fi
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% append@tabular@tail
%
% appends command to the end of \tabular@text@htail
% NOTE: command MUST be a command but without the \
%   Eg. \append@tabular@tail{relax}
%
% used to define \tabular@tail for the tabular environment
% used by the position environment
%
\def\append@tabular@tail#1{%
  \ifnum\the\c@numberofcolumns=0\relax
  \else
    \iftoks\tabular@tail\undefined@token\then
    \else
      \@append{\noexpand\\}\to\tabular@tail
      \@append{\noexpand\penalty-\@secpenalty}\to\tabular@tail
    \skotfi
    \@append{\noexpand\begin{ncolumn}}\to\tabular@tail
    \@append{\expandafter{\the\c@numberofcolumns}}\to\tabular@tail
    \@append{\the\csname#1\endcsname}\to\tabular@tail
    \@append{\noexpand\end{ncolumn}}\to\tabular@tail
  \fi
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% put the actual job descriptions here
% \begin{postion} ... \end{duties}
% in the ... describe the position.
% don't put the \dates \location etc in here. define them before hand
\newenvironment{duties}%
  {%
   \begingroup
     \par
       \the\tabular@head
%     \addpenalty{-\@secpenalty}% bad place for a page break
     \penalty -\@secpenalty % bad place for a page break
     \penalty 10000
     \ignorespaces
  }{%
       \the\tabular@tail
%     \addpenalty{\@secpenalty}% good place for a page break
     \penalty \@secpenalty % good place for a page break
    \endgroup
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEFAULTS: (the rest of them)
%
% centered name
% overlapped section titles
%
% format is:
%    title   employer
%    location    dates
%    body
% with everything in the left of its column

\@secpenalty = -500
\headheight 0pt
\headsep 0pt
\parindent 0pt
\marginparwidth 0pt
\oddsidemargin -5mm
\leftskip 6.5ex
\evensidemargin -11mm
\textwidth=165mm
\itemsep=0cm
\parsep=0cm
\parskip \baselineskip
\topmargin -8mm
\textheight 235mm
%\setcounter{secnumdepth}{0}
\def\@listI{\leftmargin\leftmargini
\topsep 0pt
\parskip 0pt
\itemsep \parsep}

\titleformat{\section}[hang]{\sc}{}{0pt}{}[]
\titlespacing{\section}{0ex}{0em}{-1em}[0pt]
\titleformat{\subsection}[runin]{\bf}{}{0pt}{}[:]
\titlespacing{\subsection}{0pt}{-1em}{\wordsep}

\begin{format}
\employer{l} \location{r} \\
\position{l} \dates{r}\\
\body\\
\end{format}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% @brief    LaTeX2e Resume Style Config
% @url      http://linux.dsplabs.com.au/?p=54
% @date     Decemebr 2007
% @author   Kamil K Wojcicki
% @info     This a fusion of CV template code by Chris Paciorek
%           (url: http://www.biostat.harvard.edu/~paciorek/computingTips/Latex_template_creating_resume_.html)
%           and res.cls class by Michael DeCorte.
%           I have merged these for educational purposes only.
\newcommand{\sbt}{\,\begin{picture}(-1,1)(-1,-3)\circle*{3}\end{picture}\ }

\newenvironment{list1}{
  \begin{list}{\sbt}{%
      \setlength{\itemsep}{0in}
      \setlength{\parsep}{0in} \setlength{\parskip}{0in}
      \setlength{\topsep}{0in} \setlength{\partopsep}{0in}
      \setlength{\leftmargin}{8.5ex}}}{\end{list}}

\newenvironment{list2}{
  \begin{list}{\sbt}{%
      \setlength{\itemsep}{0in}
      \setlength{\parsep}{0in} \setlength{\parskip}{0in}
      \setlength{\topsep}{0in} \setlength{\partopsep}{0in}
      \setlength{\leftmargin}{11.5ex}}}{\end{list}}


\newcommand{\education}[0]{
    \begin{format}
      \degree{l}\dates{r}\\
      \institute{l}\location{r}\\
      \topic{l}\\
      \advisor{l}\\
    \end{format}
    \section{Education}
}

\newcommand{\students}[0]{
    \begin{format}
      \student{l}\dates{r}\\
      \institute{l}\location{r}\\
      \body\\
    \end{format}
    \section{Student Advising}
}

\newcommand{\teaching}[0]{
    \begin{format}
      \course{l}\dates{r}\\
      \body\\
    \end{format}
    \section{Teaching Experience}
}

\newcommand{\experience}[0]{
    \begin{format}
      \employer{l}\location{r}\\
      \position{l}\dates{r}\\
      \body\\
    \end{format}
    \section{Professional Experience}
}

\newcommand{\honors}[0]{
    \section{Honors and Awards}
}

\newcommand{\skills}[0]{
    \section{Skills}
}

\newcommand{\category}[2]{
    \subsection{#1} #2
}

\newcommand{\publications}[0]{
    \section{Publications and Presentations}
}
\newcommand{\interests}[0]{
    \section{Research Interests}
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

