# Statistics
## absorption.svg
[![absorption.svg](quantum/absorption/absorption.svg "absorption.svg")](quantum/absorption/absorption.svg) [[PDF]](quantum/absorption/absorption.pdf) [[PNG]](quantum/absorption/absorption.png) [[SVG]](quantum/absorption/absorption.svg)
~~~.tex
\documentclass[crop,tikz]{standalone}

\usepackage{amsmath}
\usepackage{pgfplots}
\usepackage[locale=DE]{siunitx}
\tikzset{>=latex}

\pgfplotsset{
  inverted/.style = {
    every axis legend/.append style={
      draw=white,
      fill=hardblack,
      text=white
    }
  },
  every non boxed x axis/.append style={
    axis line style={-latex}
  },
  every non boxed y axis/.append style={
    axis line style={-latex}
  }
}

\begin{document}
\begin{tikzpicture}
\pgfmathsetmacro{\damp}{1}
\begin{axis}[
  thick,
  width=7cm,
  height=6cm,
  domain={0}:{4},
  samples=100,
  smooth,
  axis y line=middle,
  axis x line=middle,
  xlabel={$x/\si{\m}$},
  ylabel={$S/(\si{\W\per\square\m})$},
  xlabel style={right},
  ylabel style={above},
  xmin=0, xmax=4.4,
  ymin=0, ymax=2.4,
  extra x ticks={0},
  extra y ticks={0},
  legend cell align={left},
  legend style={at={(1,1)},anchor=north east}
  ]
  \addplot[red] { 2*exp(-\damp*x) };
  \addlegendentry{$S(x)=\SI{2}{\W\per\square\m}\operatorname{e}^{-\SI{\damp}{\per\m} x}$};
\end{axis}
\end{tikzpicture}
\end{document}
~~~
## absorption_inverted.svg
[![absorption_inverted.svg](quantum/absorption/absorption_inverted.svg "absorption_inverted.svg")](quantum/absorption/absorption_inverted.svg) [[PDF]](quantum/absorption/absorption_inverted.pdf) [[PNG]](quantum/absorption/absorption_inverted.png) [[SVG]](quantum/absorption/absorption_inverted.svg)
~~~.tex
\documentclass[crop,tikz]{standalone}
\usetikzlibrary{backgrounds}
\colorlet{blue}{cyan}
\tikzset{
  inverted/.style = {
    color=white,
    background rectangle/.style={fill},
    show background rectangle
  }
}

\usepackage{amsmath}
\usepackage{pgfplots}
\usepackage[locale=DE]{siunitx}
\tikzset{>=latex}

\pgfplotsset{
  inverted/.style = {
    every axis legend/.append style={
      draw=white,
      fill=black,
      text=white
    }
  },
  every non boxed x axis/.append style={
    axis line style={-latex}
  },
  every non boxed y axis/.append style={
    axis line style={-latex}
  }
}

\begin{document}
\begin{tikzpicture}[inverted,inverted]
\pgfmathsetmacro{\damp}{1}
\begin{axis}[inverted,
  thick,
  width=7cm,
  height=6cm,
  domain={0}:{4},
  samples=100,
  smooth,
  axis y line=middle,
  axis x line=middle,
  xlabel={$x/\si{\m}$},
  ylabel={$S/(\si{\W\per\square\m})$},
  xlabel style={right},
  ylabel style={above},
  xmin=0, xmax=4.4,
  ymin=0, ymax=2.4,
  extra x ticks={0},
  extra y ticks={0},
  legend cell align={left},
  legend style={at={(1,1)},anchor=north east}
  ]
  \addplot[red] { 2*exp(-\damp*x) };
  \addlegendentry{$S(x)=\SI{2}{\W\per\square\m}\operatorname{e}^{-\SI{\damp}{\per\m} x}$};
\end{axis}
\end{tikzpicture}
\end{document}
~~~
