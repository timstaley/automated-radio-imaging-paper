MANUSCRIPT_NAME=automated_radio_reduction

for FILESUFFIX in aux bib blg fdb_latexmk fls log out pdf spl; do
    rm -fv build/${MANUSCRIPT_NAME}.${FILESUFFIX}
done

rm -rfv build/CMake*
rm -fv build/cmake*
rm -fv build/Makefile
