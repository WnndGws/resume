%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Version 2.0
%
% This template has been modified from a template downloaded on 2016/01/15 from:
% http://www.LaTeXTemplates.com
%
% Original author:
% Carmine Spagnuolo (cspagnuolo@unisa.it)
%
% Major modifications by:
% Vel (vel@LaTeXTemplates.com)
%
% Major final modifications by:
% Wynand Gouws (https://github.com/WnndGws)
%
% License:
% The MIT License (see included LICENSE file)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%----------------------------------------------------------------------------------------
%	 PREAMBLE
%----------------------------------------------------------------------------------------

\ProvidesClass{resume}[2020/12/04 Resume Class for a nice looking resume]
\LoadClass{article}
\NeedsTeXFormat{LaTeX2e}

%----------------------------------------------------------------------------------------
%	 REQUIRED PACKAGES
%----------------------------------------------------------------------------------------

\RequirePackage[T1]{fontenc}
\RequirePackage{tikz}
\usetikzlibrary{shapes.geometric, calc}
\RequirePackage{xcolor}
\RequirePackage[absolute,overlay]{textpos}
\RequirePackage{ragged2e}
\RequirePackage{etoolbox}
\RequirePackage{enumitem}
\RequirePackage{ifmtarg}
\RequirePackage{ifthen}
\RequirePackage{pgffor}
\RequirePackage{marvosym}
\RequirePackage{parskip}
\RequirePackage{fontawesome}
\RequirePackage{array}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

%----------------------------------------------------------------------------------------
%	 COLOURS FOR RESUME
%----------------------------------------------------------------------------------------

\definecolor{white}{RGB}{255,255,255}
\definecolor{gray}{HTML}{4D4D4D}
\definecolor{sidecolor}{HTML}{E7E7E7}
\definecolor{mainblue}{HTML}{0E5484}
\definecolor{maingray}{HTML}{B9B9B9}

%----------------------------------------------------------------------------------------
%	 CONFIGURATIONS
%----------------------------------------------------------------------------------------

%\renewcommand{\bfseries}{\color{gray}} % Make \textbf produce coloured text instead
\pagestyle{empty} % Disable headers and footers
\tolerance=1 % Normally the lower the value, the better the paragraph will look, but you run the risk of reducing the list of possible breaks so much that you end up with overfull lines. Can range 0 to 10000
\emergencystretch=\maxdimen%% parameter which stretches text over multiple passes to balance the spacing to the set tolerance
\hyphenpenalty=10000 % basically infinite. Wont use hyphens over line breaks
\hbadness=10000 % Tells TeX at what point to report badness errors (i.e. underfull and overfull error). 0 to 10000. Large number is basically dont report
\setlength{\parindent}{0pt} % Disable paragraph indentation

%----------------------------------------------------------------------------------------
%	 SIDEBAR DEFINITIONS
%----------------------------------------------------------------------------------------

\setlength{\TPHorizModule}{1cm} % Left margin
\setlength{\TPVertModule}{2.0cm} % Top margin

\newlength\imagewidth%
\newlength\imagescale%
\pgfmathsetlength{\imagewidth}{5cm}
\pgfmathsetlength{\imagescale}{\imagewidth/600}

\newlength{\TotalSectionLength} % Define a new length to hold the remaining line width after the section title is printed
\newlength{\SectionTitleLength} % Define a new length to hold the width of the section title

\newcommand{\profilesection}[1]{% Takes the title of the section as an argument
    \setlength\TotalSectionLength{\linewidth}% Set the total line width
    \settowidth{\SectionTitleLength}{\huge #1 }% Calculate the width of the section title
    \addtolength\TotalSectionLength{-\SectionTitleLength}% Subtract the section title width from the total width
    \addtolength\TotalSectionLength{-2.22221pt}% Modifier to remove overfull box warning
    \vspace{8pt}% Whitespace before the section title
    {\color{black!80} \huge #1 \rule[0.15\baselineskip]{\TotalSectionLength}{1pt}}% Print the title and auto-width rule
}

% Define custom commands for CV info
\newcommand{\cvdate}[1]{\renewcommand{\cvdate}{#1}}
\newcommand{\cvmail}[1]{\renewcommand{\cvmail}{#1}}
\newcommand{\cvnumberphone}[1]{\renewcommand{\cvnumberphone}{#1}}
\newcommand{\cvaddress}[1]{\renewcommand{\cvaddress}{#1}}
\newcommand{\cvsite}[1]{\renewcommand{\cvsite}{#1}}
\newcommand{\aboutme}[1]{\renewcommand{\aboutme}{#1}}
\newcommand{\profilepic}[1]{\renewcommand{\profilepic}{#1}}
\newcommand{\cvname}[1]{\renewcommand{\cvname}{#1}}
\newcommand{\cvjobtitle}[1]{\renewcommand{\cvjobtitle}{#1}}
\newcommand{\cvgit}[1]{\renewcommand{\cvgit}{#1}}

% Command for printing the contact information icons
\newcommand*\icon[1]{\tikz[baseline= (char.base)]{\node[shape=circle,draw,inner sep=1pt, fill=mainblue,mainblue,text=white] (char) {#1};}}

% Command for printing stars filled by floating points for use in skills
\newcommand\stars[1]{%
  \pgfmathsetmacro\pgfxa{#1 + 1}
  \tikzstyle{scorestars}=[star, star points=5, star point ratio=2.25, draw, inner sep=0.15em, anchor=outer point 3] % Set star parameters
  \begin{tikzpicture}[baseline]
    \foreach \i in {1, ..., 5} { % How many stars do you want
      \pgfmathparse{\i<=#1 ? "mainblue" : "maingray"} % Colours of the star
      \edef\starcolor{\pgfmathresult}
      \draw (\i*1em, 0) node[name=star\i, scorestars, fill=\starcolor]  {};
    }
    \pgfmathparse{#1>int(#1) ? int(#1+1) : 0}
    \let\partstar=\pgfmathresult
    \ifnum\partstar>0
      \pgfmathsetmacro\starpart{#1-(int(#1)}
      \path [clip] ($(star\partstar.outer point 3)!(star\partstar.outer point 2)!(star\partstar.outer point 4)$) rectangle 
      ($(star\partstar.outer point 2 |- star\partstar.outer point 1)!\starpart!(star\partstar.outer point 1 -| star\partstar.outer point 5)$);
      \fill (\partstar*1em, 0) node[scorestars, fill=mainblue]  {};
    \fi
  \end{tikzpicture}%
}

% Command for using star skills out of 5 for TECHNICAL SKILLS
\newcommand\skillsstarstech[1]{
    \renewcommand{\skillsstarstech}{
        \foreach[count=\i] \x/\y in {#1}{
            \begin{itemize}[leftmargin=0.5cm]
                \item{\x}\newline
                \LARGE{\stars{\y}}
            \end{itemize}
        }
    }
}

% Command for using bar skills for TECHNICAL SKILLS
\newcommand\skillsbartech[1]{ 
    \renewcommand{\skillsbartech}{
        % Use below for bars out of 10
        \begin{tikzpicture}
            \foreach [count=\i] \x/\y in {#1}{
                \draw[fill=maingray,maingray] (0,-\i) rectangle (6,-\i+0.4);
                \draw[fill=white,mainblue](0,-\i) rectangle (0.6*\y,-\i+0.4);
                \node [above right ] at (0,-\i+0.4) {\x};
                \foreach \z in {0,1,2,...,10}{
                    \coordinate (A\z) at ($(0,-\i)+(1.2*\z*0.5cm,0)$) {};
                    \ifodd\z
                        \draw[white] ($(A\z)$) -- ($(A\z)+(0,2.5pt)$);
                    \else
                        \draw[white] ($(A\z)$) -- ($(A\z)+(0,5pt)$);
                    \fi
                }
            }
        \end{tikzpicture}
    }
}

% Command for printing skills text for TECHNICAL SKILLS
\newcommand\skillstexttech[1]{
    \renewcommand{\skillstexttech}{
        \begin{flushleft}
        \foreach[count=\i] \x in {#1}{ 
            \begin{itemize}[leftmargin=0.5cm]
                \item \x
            \end{itemize}
        }
        \end{flushleft}
    }
}

% Command for using just text for PERSONAL SKILLS
\newcommand\skillstextpersonal[1]{
    \renewcommand{\skillstextpersonal}{
        \begin{flushleft}
        \foreach[count=\i] \x in {#1}{ 
            \begin{itemize}[leftmargin=0.5cm]
                \item \x
            \end{itemize}
        }
        \end{flushleft}
    }
}

% Command for printing references without positional information
\newcommand{\shortreferences}[1]{
    \renewcommand{\shortreferences}{
        \foreach[count=\i] \w/\x/\y/ in {#1}{
            \renewcommand{\arraystretch}{1.6}
            \begin{tabular}{p{0.5cm} @{\hskip 0.5cm}p{5cm}}
                \textsc{\large\icon{\faUser}} & \textbf{\w}\\
                \textsc{\large\icon{\faHome}} & \x\\
                \textsc{\large\icon{\faPencil}} & \y\\\\
            \end{tabular}
        }
    }
}

% Command for printing references with an extra field
\newcommand{\references}[1]{
    \renewcommand{\references}{
        \foreach[count=\i] \w/\x/\y/\z in {#1}{
            \renewcommand{\arraystretch}{1.6}
            \begin{tabular}{p{0.5cm} @{\hskip 0.5cm}p{5cm}}
                \textsc{\large\icon{\faUser}} & \textbf{\w}\\
                \textsc{\large\icon{\faHome}} & \x\\
                \textsc{\large\icon{\faWpforms}} & \y\\
                \textsc{\large\icon{\faPencil}} & \z\\\\
            \end{tabular}
        }
    }
}

%----------------------------------------------------------------------------------------
%	 SIDEBAR LAYOUT
%----------------------------------------------------------------------------------------

\newcommand{\makeprofile}{
    % Create a grey(sidecolor) box of 9cm for the side of the resume
    \begin{tikzpicture}[remember picture,overlay]
        \node [rectangle, fill=sidecolor, anchor=north, minimum width=9cm, minimum height=\paperheight+1cm] (box) at (-5cm,0.5cm){};
    \end{tikzpicture}

    % Text block{width}(XCOORDINATE,YCOORDINATE)
    \begin{textblock}{6} (0.5, 0.2)
        % If profile pic include it at the top in a circle
        \ifthenelse{\equal{\profilepic}{}}{}{
            \begin{center}
            \begin{tikzpicture}[x=\imagescale,y=-\imagescale]
                \clip (600/2, 567/2) circle (567/2);
                \node[anchor=north west, inner sep=0pt, outer sep=0pt] at (0,0) {\includegraphics[width=\imagewidth]{\profilepic}};
            \end{tikzpicture}
            \end{center}
        }

        % Include person's name
	{\huge\color{mainblue}{\bf \cvname}}

        % Include job title
	{\Large\color{black!80}\cvjobtitle}

        % Include all of these if they are specified
        % arraystretch is a FACTOR representing the distance between two rows. Default is 1
        \renewcommand{\arraystretch}{1.6}
            \begin{tabular}{p{0.5cm} @{\hskip 0.5cm}p{5cm}}
                \ifthenelse{\equal{\cvdate}{}}{}{\textsc{\Large\icon{\Info}} & \cvdate\\}
                \ifthenelse{\equal{\cvaddress}{}}{}{\textsc{\large\icon{\faHome}} & \cvaddress\\}
                \ifthenelse{\equal{\cvnumberphone}{}}{}{\textsc{\large\icon{\faPhone}} & \cvnumberphone\\}
                \ifthenelse{\equal{\cvsite}{}}{}{\textsc{\Large\icon{\Mundus}} & \cvsite\\}
                \ifthenelse{\equal{\cvgit}{}}{}{\textsc{\large\icon{\faGithub}} & \cvgit\\}
                \ifthenelse{\equal{\cvmail}{}}{}{\textsc{\Large\icon{\Letter}} & \href{mailto:\cvmail}{\cvmail}}
            \end{tabular}
		
        % Include aboutme if present
        \ifthenelse{\equal{\aboutme}{}}{}{
            \profilesection{About me}
            \begin{justify}
                \aboutme%
            \end{justify}
        }

        % TODO figure out why can have other 2 alone but not bars alone, suspect "itemize" is why
        % Choose if stars, bars, or text for technical skills
        \profilesection{Technical Skills}
            %\skillsstarstech%
            \skillsbartech%
            %\skillstexttech%

        % Include Personal skills
        \profilesection{Personal Skills}
            \skillstextpersonal%

        % Include reference
	\profilesection{References}
            \references%
            \shortreferences%

    \end{textblock}
}

%----------------------------------------------------------------------------------------
%	 COLOURED SECTION TITLE BOX
%----------------------------------------------------------------------------------------

% Command to create the rounded boxes around the section titles
\newcommand*\round[2]{
    \tikz[baseline= (char.base)]\node[anchor=north west, draw,rectangle, rounded corners, inner sep=1.6pt, minimum size=5.5mm, text height=3.6mm, fill=#2,#2,text=white] (char){#1};
}

\newcounter{colorCounter}
\newcommand{\sectioncolor}[1]{
    {\round{#1}{
        \ifcase\value{colorCounter}
            mainblue\or%
            mainblue\or%
            mainblue\or%
            mainblue\or%
            mainblue\or%
            mainblue\or%
            mainblue\or%
            mainblue\else%
            mainblue\fi%
        }%
    }%
    \stepcounter{colorCounter}%
}

% TODO below this

\renewcommand{\section}[1]{
	{%
		\color{gray}%
		\Large\sectioncolor{#1}%
	}
}

\renewcommand{\subsection}[1]{
	\par\vspace{.5\parskip}{%
		\large\color{gray} #1%
	}
	\par\vspace{.25\parskip}%
}

%----------------------------------------------------------------------------------------
%	 LONG LIST ENVIRONMENT
%----------------------------------------------------------------------------------------

% New environment for the long list

\setlength{\tabcolsep}{0pt}
\newenvironment{sidebarlonglist}{%
  \begin{tabular}{ll}
}{%
  \end{tabular}
}

\newcommand{\sidebarlonglistitem}[4]{%
	\parbox[t]{1.8cm}%
    {{\textcolor{gray}{#1}}}&%

    \parbox[t]{10.5cm}%
    {{\bfseries{\textcolor{gray}{#2}}}\hfill{\textcolor{mainblue}{\footnotesize#3}}\\{\textcolor{gray}{#4}}}%
\\\\}


%----------------------------------------------------------------------------------------
%	 SMALL LIST ENVIRONMENT
%----------------------------------------------------------------------------------------

\setlength{\tabcolsep}{0pt}

% New environment for the small list
\newenvironment{sidebarshortlist}{%
	\begin{tabular}{ll}
}{%
	\end{tabular}
}

\newcommand{\sidebarshortlistitem}[2]{%
	\parbox[t]{1.8cm}%
    {{\textcolor{gray}{#1}}}&%

    \parbox[t]{10.5cm}%
    {{\bfseries{\textcolor{gray}{#2}}}}%
\\\\}

%----------------------------------------------------------------------------------------
%	 MARGINS AND LINKS
%----------------------------------------------------------------------------------------

\RequirePackage[left=7.6cm,top=0.1cm,right=1cm,bottom=0.2cm,nohead,nofoot]{geometry}

\RequirePackage{hyperref}
