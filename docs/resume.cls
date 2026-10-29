%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Medium Length Professional CV - RESUME CLASS FILE
%
% This template has been downloaded from:
% http://www.LaTeXTemplates.com
%
% This class file defines the structure and design of the template.
%
% Original header:
% Copyright (C) 2010 by Trey Hunner
%
% Copying and distribution of this file, with or without modification,
% are permitted in any medium without royalty provided the copyright
% notice and this notice are preserved. This file is offered as-is,
% without any warranty.
%
% Created by Trey Hunner and modified by www.LaTeXTemplates.com
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\ProvidesClass{resume}[2010/07/10 v0.9 Resume class]

\LoadClass[11pt,letterpaper]{article} % Font size and paper type
\frenchspacing % 마침표 뒤 간격을 일반 띄어쓰기와 같게 (Dr. / Prof. 뒤가 벌어지는 것 방지)

\usepackage[parfill]{parskip} % Remove paragraph indentation
\usepackage{array} % Required for boldface (\bf and \bfseries) tabular columns
\usepackage{ifthen} % Required for ifthenelse statements
\RequirePackage[T1]{fontenc}        % \_ 를 진짜 밑줄 글자로
\RequirePackage{newtxtext}          % Times 계열 (없으면 tgtermes / mathptmx)
\RequirePackage{geometry}            % 여백 (.tex에서 \geometry{...}로 다시 조정 가능)
\geometry{margin=0.4in,includefoot,footskip=18pt,headheight=14pt} % 사방 0.4in; 쪽번호(footer)도 여백 안쪽에 두기 (includefoot)
\setlength{\emergencystretch}{2em}    % 긴 단어 때문에 줄이 오른쪽으로 삐져나가는 것(Overfull) 완화
\RequirePackage{fancyhdr}            % 쪽번호
\RequirePackage{iftex}
\ifXeTeX
  \RequirePackage{microtype}                 % XeLaTeX: 자간 기능 없음 → 조판 품질만
  \def\datetracking{}
\else
  \RequirePackage[letterspace=60]{microtype} % pdfLaTeX/LuaLaTeX: 날짜 열 자간(\lsstyle) 사용
  \def\datetracking{\lsstyle}
\fi
\RequirePackage{needspace}           % 섹션 제목만 페이지 끝에 홀로 남는 것 방지
\RequirePackage[hidelinks]{hyperref} % 이메일·홈페이지 링크
\urlstyle{same}                     % \nolinkurl 을 본문 글꼴로

\pagestyle{fancy}\fancyhf{}              % 머리글/바닥글 비우기
\renewcommand{\headrulewidth}{0pt}
\fancyfoot[C]{- \thepage\ -}             % 참고 CV처럼 "- 1 -" 쪽번호. 없애려면 이 세 줄 대신 \pagestyle{empty}

%----------------------------------------------------------------------------------------
%	HEADINGS COMMANDS: Commands for printing name and address
%----------------------------------------------------------------------------------------

\def \name#1{\def\@name{#1}} % Defines the \name command to set name
\def \@name {} % Sets \@name to empty by default

% \def \addressSep {$\diamond$} % Set default address separator to a diamond

\def\addressSep{\enspace|\enspace}

% One, two or three address lines can be specified
\let \@addressone \relax
\let \@addresstwo \relax
\let \@addressthree \relax

% \address command can be used to set the first, second, and third address (last 2 optional)
\def \address #1{
  \@ifundefined{@addresstwo}{
    \def \@addresstwo {#1}
  }{
  \@ifundefined{@addressthree}{
  \def \@addressthree {#1}
  }{
     \def \@addressone {#1}
  }}
}

% \printaddress is used to style an address line (given as input)
\def \printaddress #1{
  \begingroup
    \def \\ {\addressSep\ }
    \centerline{#1}
  \endgroup
  \par
  \addressskip
}

% \fakesc: 각 단어의 첫 글자는 \namesize, 나머지는 \namesmall 크기의 대문자로 (Word식 small caps)
\def\fsc@word#1#2\@nil{\MakeUppercase{#1}{\namesmall\MakeUppercase{#2}}}
\def\fsc@loop#1 #2\@nil{\fsc@word#1\@nil\ifx\relax#2\relax\else\ \fsc@loop#2\@nil\fi}
\def\fakesc#1{\fsc@loop#1 \@nil}

% \printname is used to print the name as a page header
\def \printname {
  \begingroup
    \centering
    {\namesize\bfseries\expandafter\fakesc\expandafter{\@name}\par}
    \nameskip
  \endgroup
}

%----------------------------------------------------------------------------------------
%	PRINT THE HEADING LINES
%----------------------------------------------------------------------------------------

\let\ori@document=\document
\renewcommand{\document}{
  \ori@document  % Begin document
  \printname % Print the name specified with \name
  \@ifundefined{@addressone}{}{ % Print the first address if specified
    \printaddress{\@addressone}}
  \@ifundefined{@addresstwo}{}{ % Print the second address if specified
    \printaddress{\@addresstwo}}
     \@ifundefined{@addressthree}{}{ % Print the third address if specified
    \printaddress{\@addressthree}}
}

%----------------------------------------------------------------------------------------
%	SECTION FORMATTING
%----------------------------------------------------------------------------------------

% Defines the rSection environment for the large sections within the CV
\newenvironment{rSection}[1]{ % 1 input argument - section name
  \Needspace*{4\baselineskip} % 제목 + 최소 두세 줄이 안 들어가면 다음 페이지로
  \sectionskip
  \MakeUppercase{\bf #1} % Section title
  \sectionlineskip
  \hrule % Horizontal line
  \setlength{\parskip}{0pt} % 밑줄과 첫 내용 사이에 parskip이 끼지 않도록
  \begin{list}{}{ % List for each individual item in the section
    \setlength{\leftmargin}{0.5em} % 참고 CV처럼 밑줄보다 아주 살짝 들여쓰기
    \setlength{\topsep}{2pt}       % 밑줄과 첫 내용 사이 간격 (원래 약 9pt)
  }
  \item[]
}{
  \end{list}
}

%----------------------------------------------------------------------------------------
%	WORK EXPERIENCE FORMATTING
%----------------------------------------------------------------------------------------

\newenvironment{rSubsection}[4]{ % 4 input arguments - company name, year(s) employed, job title and location
 {\bf #1} \hfill {#2} % Bold company name and date on the right
 \ifthenelse{\equal{#3}{}}{}{ % If the third argument is not specified, don't print the job title and location line
  \\
  {\em #3} \hfill {\em #4} % Italic job title and location
  }\smallskip
  \begin{list}{$\cdot$}{\leftmargin=0em} % \cdot used for bullets, no indentation
   \itemsep -0.5em \vspace{-0.5em} % Compress items in list together for aesthetics
  }{
  \end{list}
  \vspace{0.5em} % Some space after the list of bullet points
}

%----------------------------------------------------------------------------------------
%	DATED ENTRY (왼쪽 기간 열 + 오른쪽 내용) — Kangyoon Lee CV 스타일
%----------------------------------------------------------------------------------------
% \begin{rDated}{기간(줄바꿈은 \\)}{굵은 제목}{오른쪽 끝 위치}{둘째 줄(학위·직함, 없으면 비워둠)}
%   \item 불릿 ...
% \end{rDated}

\newlength{\datecolwidth}\setlength{\datecolwidth}{5.4em}  % 기간 열 폭 ("Mar. 2019 –"가 들어가는 폭)
\newlength{\datecolsep}\setlength{\datecolsep}{1.0em}      % 기간과 내용 사이 간격
% rList(Scholarships/Awards) 날짜 열: 폭을 \listdatewidth로 고정하고 월은 왼쪽, 연도는 오른쪽 끝에 맞춤
% (월 약어 폭이 달라도 연도가 세로로 정렬됨; 참고 CV처럼 자간도 살짝). 내용 시작 위치는 rDated와 동일.
\newlength{\listdatewidth}\setlength{\listdatewidth}{5.0em}
\def\datestyle{\datetracking\parfillskip=0pt\relax\spaceskip=0.45em plus 1fill\relax\hbadness=10000\relax}
\newlength{\entryskip}\setlength{\entryskip}{0.4em}        % 항목(entry) 사이 간격

\newenvironment{rDated}[4]{%
  \begin{list}{}{%
    \setlength{\labelwidth}{\datecolwidth}%
    \setlength{\labelsep}{\datecolsep}%
    \setlength{\leftmargin}{\dimexpr\datecolwidth+\datecolsep\relax}%
    \setlength{\itemindent}{0pt}\setlength{\listparindent}{0pt}%
    \setlength{\topsep}{0pt}\setlength{\partopsep}{0pt}%
    \setlength{\parsep}{0pt}\setlength{\itemsep}{0pt}%
  }%
  \item[{\raisebox{0pt}[0pt][0pt]{\parbox[t]{\datecolwidth}{\raggedright #1}}}]%
  {\bf #2}\hfill #3%
  \ifthenelse{\equal{#4}{}}{}{\\ #4}%
  \begin{list}{\textbullet}{%
    \setlength{\leftmargin}{1.6em}\setlength{\labelsep}{0.5em}%
    \setlength{\topsep}{0pt}\setlength{\partopsep}{0pt}%
    \setlength{\parsep}{0pt}\setlength{\itemsep}{0pt}%
  }%
}{%
  \end{list}%
  \end{list}%
  \vspace{\entryskip}%
}

% \begin{rList} 날짜 & 내용 \\ ... \end{rList} — Scholarships/Awards처럼 한 줄짜리 항목 (왼쪽 날짜 열 공유)
\newenvironment{rList}{%
  \renewcommand{\arraystretch}{1.0}%   % 행 간격 = 본문 줄 간격 (참고 CV처럼 촘촘하게)
  \begin{tabular}{@{}>{\datestyle}p{\listdatewidth}@{\hspace{\dimexpr\datecolwidth+\datecolsep-\listdatewidth\relax}}p{\dimexpr\linewidth-\datecolwidth-\datecolsep\relax}@{}}%
}{%
  \end{tabular}\par\vspace{\entryskip}%
}

% The below commands define the whitespace after certain things in the document - they can be \smallskip, \medskip or \bigskip

% \def\namesize{\huge} % Size of the name at the top of the
\def\namesize{\fontsize{18}{22}\selectfont}  % 이름 각 단어의 첫 글자 크기
\def\namesmall{\fontsize{16}{18}\selectfont} % 이름 나머지 글자 크기

\def\addressskip{\smallskip} % The space between the two address (or phone/email) lines

% \def\sectionlineskip{\medskip} % The space above the horizontal line for each section
\def\sectionlineskip{\normalsize\smallskip}

\def\nameskip{\smallskip} % The space after your name at the top (참고 CV처럼 연락처를 이름에 붙임, 원래는 \bigskip)

% \def\sectionskip{\medskip} % The space after the heading section
\def\sectionskip{\medskip\large}

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Medium Length Professional CV - RESUME CLASS FILE
% %
% % This template has been downloaded from:
% % http://www.LaTeXTemplates.com
% %
% % This class file defines the structure and design of the template.
% %
% % Original header:
% % Copyright (C) 2010 by Trey Hunner
% %
% % Copying and distribution of this file, with or without modification,
% % are permitted in any medium without royalty provided the copyright
% % notice and this notice are preserved. This file is offered as-is,
% % without any warranty.
% %
% % Created by Trey Hunner and modified by www.LaTeXTemplates.com
% %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% \ProvidesClass{resume}[2010/07/10 v0.9 Resume class]

% \LoadClass[11pt,letterpaper]{article} % Font size and paper type
% \frenchspacing

% \usepackage[parfill]{parskip} % Remove paragraph indentation
% \usepackage{array} % Required for boldface (\bf and \bfseries) tabular columns
% \usepackage{ifthen} % Required for ifthenelse statements
% \RequirePackage[T1]{fontenc}        % \_ 를 진짜 밑줄 글자로
% \RequirePackage{newtxtext}          % Times 계열 (없으면 tgtermes / mathptmx)
% \RequirePackage{geometry}            % 여백 (.tex에서 \geometry{...}로 다시 조정 가능)
% \geometry{margin=0.4in,headheight=14pt} % 참고 CV와 같은 사방 1인치
% \setlength{\emergencystretch}{2em}    % 긴 단어 때문에 줄이 오른쪽으로 삐져나가는 것(Overfull) 완화
% \RequirePackage{fancyhdr}            % 쪽번호
% \RequirePackage[hidelinks]{hyperref} % 이메일·홈페이지 링크
% \urlstyle{same}                     % \nolinkurl 을 본문 글꼴로

% \pagestyle{fancy}\fancyhf{}              % 머리글/바닥글 비우기
% \renewcommand{\headrulewidth}{0pt}
% \fancyfoot[C]{- \thepage\ -}             % 참고 CV처럼 "- 1 -" 쪽번호. 없애려면 이 세 줄 대신 \pagestyle{empty}

% %----------------------------------------------------------------------------------------
% %	HEADINGS COMMANDS: Commands for printing name and address
% %----------------------------------------------------------------------------------------

% \def \name#1{\def\@name{#1}} % Defines the \name command to set name
% \def \@name {} % Sets \@name to empty by default

% % \def \addressSep {$\diamond$} % Set default address separator to a diamond

% \def\addressSep{\enspace|\enspace}

% % One, two or three address lines can be specified
% \let \@addressone \relax
% \let \@addresstwo \relax
% \let \@addressthree \relax

% % \address command can be used to set the first, second, and third address (last 2 optional)
% \def \address #1{
%   \@ifundefined{@addresstwo}{
%     \def \@addresstwo {#1}
%   }{
%   \@ifundefined{@addressthree}{
%   \def \@addressthree {#1}
%   }{
%      \def \@addressone {#1}
%   }}
% }

% % \printaddress is used to style an address line (given as input)
% \def \printaddress #1{
%   \begingroup
%     \def \\ {\addressSep\ }
%     \centerline{#1}
%   \endgroup
%   \par
%   \addressskip
% }

% % \fakesc: 각 단어의 첫 글자는 \namesize, 나머지는 \namesmall 크기의 대문자로 (Word식 small caps)
% \def\fsc@word#1#2\@nil{\MakeUppercase{#1}{\namesmall\MakeUppercase{#2}}}
% \def\fsc@loop#1 #2\@nil{\fsc@word#1\@nil\ifx\relax#2\relax\else\ \fsc@loop#2\@nil\fi}
% \def\fakesc#1{\fsc@loop#1 \@nil}

% % \printname is used to print the name as a page header
% \def \printname {
%   \begingroup
%     \hfil{\namesize\bfseries\expandafter\fakesc\expandafter{\@name}}\hfil
%     \nameskip\break
%   \endgroup
% }

% %----------------------------------------------------------------------------------------
% %	PRINT THE HEADING LINES
% %----------------------------------------------------------------------------------------

% \let\ori@document=\document
% \renewcommand{\document}{
%   \ori@document  % Begin document
%   \printname % Print the name specified with \name
%   \@ifundefined{@addressone}{}{ % Print the first address if specified
%     \printaddress{\@addressone}}
%   \@ifundefined{@addresstwo}{}{ % Print the second address if specified
%     \printaddress{\@addresstwo}}
%      \@ifundefined{@addressthree}{}{ % Print the third address if specified
%     \printaddress{\@addressthree}}
% }

% %----------------------------------------------------------------------------------------
% %	SECTION FORMATTING
% %----------------------------------------------------------------------------------------

% % Defines the rSection environment for the large sections within the CV
% \newenvironment{rSection}[1]{ % 1 input argument - section name
%   \sectionskip
%   \MakeUppercase{\bf #1} % Section title
%   \sectionlineskip
%   \hrule % Horizontal line
%   \begin{list}{}{ % List for each individual item in the section
%     \setlength{\leftmargin}{0em} % Margin within the section (참고 CV처럼 들여쓰기 없음)
%   }
%   \item[]
% }{
%   \end{list}
% }

% %----------------------------------------------------------------------------------------
% %	WORK EXPERIENCE FORMATTING
% %----------------------------------------------------------------------------------------

% \newenvironment{rSubsection}[4]{ % 4 input arguments - company name, year(s) employed, job title and location
%  {\bf #1} \hfill {#2} % Bold company name and date on the right
%  \ifthenelse{\equal{#3}{}}{}{ % If the third argument is not specified, don't print the job title and location line
%   \\
%   {\em #3} \hfill {\em #4} % Italic job title and location
%   }\smallskip
%   \begin{list}{$\cdot$}{\leftmargin=0em} % \cdot used for bullets, no indentation
%    \itemsep -0.5em \vspace{-0.5em} % Compress items in list together for aesthetics
%   }{
%   \end{list}
%   \vspace{0.5em} % Some space after the list of bullet points
% }

% %----------------------------------------------------------------------------------------
% %	DATED ENTRY (왼쪽 기간 열 + 오른쪽 내용) — Kangyoon Lee CV 스타일
% %----------------------------------------------------------------------------------------
% % \begin{rDated}{기간(줄바꿈은 \\)}{굵은 제목}{오른쪽 끝 위치}{둘째 줄(학위·직함, 없으면 비워둠)}
% %   \item 불릿 ...
% % \end{rDated}

% \newlength{\datecolwidth}\setlength{\datecolwidth}{6.2em}  % 기간 글자 폭
% \newlength{\datecolsep}\setlength{\datecolsep}{1.2em}      % 기간과 내용 사이 간격
% \newlength{\entryskip}\setlength{\entryskip}{0.4em}        % 항목(entry) 사이 간격

% \newenvironment{rDated}[4]{%
%   \begin{list}{}{%
%     \setlength{\labelwidth}{\datecolwidth}%
%     \setlength{\labelsep}{\datecolsep}%
%     \setlength{\leftmargin}{\dimexpr\datecolwidth+\datecolsep\relax}%
%     \setlength{\itemindent}{0pt}\setlength{\listparindent}{0pt}%
%     \setlength{\topsep}{0pt}\setlength{\partopsep}{0pt}%
%     \setlength{\parsep}{0pt}\setlength{\itemsep}{0pt}%
%   }%
%   \item[{\raisebox{0pt}[0pt][0pt]{\parbox[t]{\datecolwidth}{\raggedright #1}}}]%
%   {\bf #2}\hfill #3%
%   \ifthenelse{\equal{#4}{}}{}{\\ #4}%
%   \begin{list}{\textbullet}{%
%     \setlength{\leftmargin}{1.6em}\setlength{\labelsep}{0.5em}%
%     \setlength{\topsep}{0pt}\setlength{\partopsep}{0pt}%
%     \setlength{\parsep}{0pt}\setlength{\itemsep}{0pt}%
%   }%
% }{%
%   \end{list}%
%   \end{list}%
%   \vspace{\entryskip}%
% }

% % \begin{rList} 날짜 & 내용 \\ ... \end{rList} — Scholarships/Awards처럼 한 줄짜리 항목 (왼쪽 날짜 열 공유)
% \newenvironment{rList}{%
%   \renewcommand{\arraystretch}{1.15}%
%   \begin{tabular}{@{}p{\datecolwidth}@{\hspace{\datecolsep}}p{\dimexpr\linewidth-\datecolwidth-\datecolsep\relax}@{}}%
% }{%
%   \end{tabular}\par\vspace{\entryskip}%
% }

% % The below commands define the whitespace after certain things in the document - they can be \smallskip, \medskip or \bigskip

% % \def\namesize{\huge} % Size of the name at the top of the
% \def\namesize{\fontsize{18}{22}\selectfont}  % 이름 각 단어의 첫 글자 크기
% \def\namesmall{\fontsize{16}{18}\selectfont} % 이름 나머지 글자 크기

% \def\addressskip{\smallskip} % The space between the two address (or phone/email) lines

% % \def\sectionlineskip{\medskip} % The space above the horizontal line for each section
% \def\sectionlineskip{\normalsize\smallskip}

% \def\nameskip{\smallskip} % The space after your name at the top (참고 CV처럼 연락처를 이름에 붙임, 원래는 \bigskip)

% % \def\sectionskip{\medskip} % The space after the heading section
% \def\sectionskip{\medskip\large}


%-----------------------------


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Medium Length Professional CV - RESUME CLASS FILE
% %
% % This template has been downloaded from:
% % http://www.LaTeXTemplates.com
% %
% % This class file defines the structure and design of the template.
% %
% % Original header:
% % Copyright (C) 2010 by Trey Hunner
% %
% % Copying and distribution of this file, with or without modification,
% % are permitted in any medium without royalty provided the copyright
% % notice and this notice are preserved. This file is offered as-is,
% % without any warranty.
% %
% % Created by Trey Hunner and modified by www.LaTeXTemplates.com
% %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% \ProvidesClass{resume}[2010/07/10 v0.9 Resume class]

% \LoadClass[11pt,letterpaper]{article} % Font size and paper type

% \usepackage[parfill]{parskip} % Remove paragraph indentation
% \usepackage{array} % Required for boldface (\bf and \bfseries) tabular columns
% \usepackage{ifthen} % Required for ifthenelse statements
% \RequirePackage[T1]{fontenc}        % \_ 를 진짜 밑줄 글자로
% \RequirePackage{newtxtext}          % Times 계열 (없으면 tgtermes / mathptmx)
% \RequirePackage[hidelinks]{hyperref} % 이메일·홈페이지 링크
% \urlstyle{same}                     % \nolinkurl 을 본문 글꼴로

% \pagestyle{empty} % Suppress page numbers

% %----------------------------------------------------------------------------------------
% %	HEADINGS COMMANDS: Commands for printing name and address
% %----------------------------------------------------------------------------------------

% \def \name#1{\def\@name{#1}} % Defines the \name command to set name
% \def \@name {} % Sets \@name to empty by default

% % \def \addressSep {$\diamond$} % Set default address separator to a diamond

% \def\addressSep{\enspace|\enspace}

% % One, two or three address lines can be specified
% \let \@addressone \relax
% \let \@addresstwo \relax
% \let \@addressthree \relax

% % \address command can be used to set the first, second, and third address (last 2 optional)
% \def \address #1{
%   \@ifundefined{@addresstwo}{
%     \def \@addresstwo {#1}
%   }{
%   \@ifundefined{@addressthree}{
%   \def \@addressthree {#1}
%   }{
%      \def \@addressone {#1}
%   }}
% }

% % \printaddress is used to style an address line (given as input)
% \def \printaddress #1{
%   \begingroup
%     \def \\ {\addressSep\ }
%     \centerline{#1}
%   \endgroup
%   \par
%   \addressskip
% }

% % % \printname is used to print the name as a page header
% % \def \printname {
% %   \begingroup
% %     \hfil{\MakeUppercase{\namesize\bf \@name}}\hfil
% %     \nameskip\break
% %   \endgroup
% % }

% % \fakesc: 각 단어의 첫 글자는 \namesize, 나머지는 \namesmall 크기의 대문자로
% \def\fsc@word#1#2\@nil{\MakeUppercase{#1}{\namesmall\MakeUppercase{#2}}}
% \def\fsc@loop#1 #2\@nil{\fsc@word#1\@nil\ifx\relax#2\relax\else\ \fsc@loop#2\@nil\fi}
% \def\fakesc#1{\fsc@loop#1 \@nil}

% % \printname is used to print the name as a page header
% \def \printname {
%   \begingroup
%     \hfil{\namesize\bfseries\expandafter\fakesc\expandafter{\@name}}\hfil
%     \nameskip\break
%   \endgroup
% }



% %----------------------------------------------------------------------------------------
% %	PRINT THE HEADING LINES
% %----------------------------------------------------------------------------------------

% \let\ori@document=\document
% \renewcommand{\document}{
%   \ori@document  % Begin document
%   \printname % Print the name specified with \name
%   \@ifundefined{@addressone}{}{ % Print the first address if specified
%     \printaddress{\@addressone}}
%   \@ifundefined{@addresstwo}{}{ % Print the second address if specified
%     \printaddress{\@addresstwo}}
%      \@ifundefined{@addressthree}{}{ % Print the third address if specified
%     \printaddress{\@addressthree}}
% }

% %----------------------------------------------------------------------------------------
% %	SECTION FORMATTING
% %----------------------------------------------------------------------------------------

% % Defines the rSection environment for the large sections within the CV
% \newenvironment{rSection}[1]{ % 1 input argument - section name
%   \sectionskip
%   \MakeUppercase{\bf #1} % Section title
%   \sectionlineskip
%   \hrule % Horizontal line
%   \begin{list}{}{ % List for each individual item in the section
%     \setlength{\leftmargin}{1.5em} % Margin within the section
%   }
%   \item[]
% }{
%   \end{list}
% }

% %----------------------------------------------------------------------------------------
% %	WORK EXPERIENCE FORMATTING
% %----------------------------------------------------------------------------------------

% \newenvironment{rSubsection}[4]{ % 4 input arguments - company name, year(s) employed, job title and location
%  {\bf #1} \hfill {#2} % Bold company name and date on the right
%  \ifthenelse{\equal{#3}{}}{}{ % If the third argument is not specified, don't print the job title and location line
%   \\
%   {\em #3} \hfill {\em #4} % Italic job title and location
%   }\smallskip
%   \begin{list}{$\cdot$}{\leftmargin=0em} % \cdot used for bullets, no indentation
%    \itemsep -0.5em \vspace{-0.5em} % Compress items in list together for aesthetics
%   }{
%   \end{list}
%   \vspace{0.5em} % Some space after the list of bullet points
% }

% % The below commands define the whitespace after certain things in the document - they can be \smallskip, \medskip or \bigskip

% % \def\namesize{\huge} % Size of the name at the top of the
% \def\namesize{\fontsize{18}{22}\selectfont}
% \def\namesmall{\fontsize{16}{18}\selectfont} % 이름 나머지 글자 크기

% \def\addressskip{\smallskip} % The space between the two address (or phone/email) lines

% % \def\sectionlineskip{\medskip} % The space above the horizontal line for each section
% \def\sectionlineskip{\normalsize\smallskip}

% \def\nameskip{\bigskip} % The space after your name at the top

% % \def\sectionskip{\medskip} % The space after the heading section
% \def\sectionskip{\medskip\large}
