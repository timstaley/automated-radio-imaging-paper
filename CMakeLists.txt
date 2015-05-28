project (version-controlled-paper)
cmake_minimum_required (VERSION 2.8)

set ( MANUSCRIPT_NAME automated_radio_reduction )

set (CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)
set (FIGURE_OUTPUT_DIR ${PROJECT_BINARY_DIR}/figures)

find_package (LATEX REQUIRED)
find_package (LatexMk REQUIRED)
find_package (PythonInterp REQUIRED)

# Versioning
execute_process (
    COMMAND git log -1 --date=short --pretty=\\newcommand{\\githash}{%h}\\newcommand{\\gitdate}{%ad}
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
    OUTPUT_VARIABLE GIT_CMD
)


# We simply copy the static figures from the source tree to the build
set (STATIC_FIGURES
)
foreach (figure ${STATIC_FIGURES})
    configure_file (
        ${PROJECT_SOURCE_DIR}/figures/${figure}
        ${FIGURE_OUTPUT_DIR}/${figure}
        COPYONLY
    )
endforeach (figure)



configure_file (
    ${PROJECT_SOURCE_DIR}/manuscript/${MANUSCRIPT_NAME}.tex
    ${PROJECT_BINARY_DIR}/${MANUSCRIPT_NAME}.tex
    @ONLY
)

configure_file (
    ${PROJECT_SOURCE_DIR}/manuscript/${MANUSCRIPT_NAME}.bib
    ${PROJECT_BINARY_DIR}/${MANUSCRIPT_NAME}.bib
    @COPYONLY
)


configure_file (
    ${PROJECT_SOURCE_DIR}/manuscript/elsarticle-harv-max8.bst
    ${PROJECT_BINARY_DIR}/elsarticle-harv-max8.bst
    @COPYONLY
)


add_custom_command (
    OUTPUT ${PROJECT_BINARY_DIR}/${MANUSCRIPT_NAME}.pdf
    COMMAND ${LATEXMK_EXECUTABLE}
    ARGS -pdf -pdflatex=\"pdflatex --shell-escape %O %S\" ${PROJECT_BINARY_DIR}/${MANUSCRIPT_NAME}.tex
    DEPENDS
        ${PROJECT_BINARY_DIR}/${MANUSCRIPT_NAME}.tex
        ${PROJECT_BINARY_DIR}/${MANUSCRIPT_NAME}.bib
#  #List of generated figures we also depend on:
#  ${FIGURE_OUTPUT_DIR}/results/V_predictedVobserved.pdf
)

add_custom_target (paper ALL echo
    DEPENDS ${PROJECT_BINARY_DIR}/${MANUSCRIPT_NAME}.pdf
)
