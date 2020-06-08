#!/bin/sh
echo
echo Usage:
echo build.sh [--test] [--no-static]
echo

inArray() {
    local e match="$1"
    shift
    for e; do [[ "$e" == "$match" ]] && return 0; done
    return 1
}

if inArray "--test" $@; then
    files=(Piazzolla-VARsetup Piazzolla-Italic-VARsetup)
else
    files=(Piazzolla Piazzolla-Italic)
fi

if inArray "--no-static" $@; then
    static=false
else
    static=true
fi

for f in "${files[@]}"; do
    echo "Setup DesignSpace from Glyphs for $f"
    if [ -e temp/building/$f ]; then rm -rf temp/building/$f; fi
    mkdir -p temp/building/$f
    glyphs2ufo sources/$f.glyphs -m temp/building/$f
    echo "Process DesignSpace for $f"
    python tools/processDesignSpace.py $f
done

echo Generating fonts
rm -rf fonts
for f in "${files[@]}"; do
    echo ""
    echo "Generate variable font for $f"
    fontmake -m temp/building/$f/$f.designspace -o variable --output-dir fonts/Piazzolla/variable --verbose WARNING
    echo "Building STAT table for $f"
    statmake --designspace temp/building/$f/$f.designspace fonts/Piazzolla/variable/"$f"-VF.ttf
    if $static; then
        echo "Generate static fonts for $f"
        fontmake -m temp/building/$f/$f.designspace -i --output-dir fonts/Piazzolla/static --verbose WARNING
    fi
done

echo ""
echo Fixing fonts
for VF in fonts/Piazzolla/variable/*.ttf; do
    gftools fix-dsig -f $VF
    gftools fix-nonhinting $VF "$VF.fix"
    mv "$VF.fix" $VF
    ttx -f -x "MVAR" $VF
    BASE=$(basename -s .ttf $VF)
    TTXFILE=fonts/Piazzolla/variable/$BASE.ttx
    rm $VF
    ttx $TTXFILE
    rm fonts/Piazzolla/variable/$BASE.ttx
    rm fonts/Piazzolla/variable/$BASE-backup-fonttools-prep-gasp.ttf
done

if $static; then
    for ttf in fonts/Piazzolla/static/*.ttf; do
        gftools fix-dsig -f $ttf
        gftools fix-nonhinting $ttf "$ttf.fix"
        mv "$ttf.fix" $ttf
        ttx -f -x "MVAR" $ttf
        BASE=$(basename -s .ttf $ttf)
        TTXFILE=fonts/Piazzolla/static/$BASE.ttx
        rm $ttf
        ttx $TTXFILE
        rm fonts/Piazzolla/static/$BASE.ttx
        rm fonts/Piazzolla/static/$BASE-backup-fonttools-prep-gasp.ttf
    done

    for otf in fonts/Piazzolla/static/*.otf; do
        gftools fix-dsig -f $otf
        gftools fix-nonhinting $otf "$otf.fix"
        mv "$otf.fix" $otf
        ttx -f -x "MVAR" $otf
        BASE=$(basename -s .otf $otf)
        TTXFILE=fonts/Piazzolla/static/$BASE.ttx
        rm $otf
        ttx $TTXFILE
        rm fonts/Piazzolla/static/$BASE.ttx
        rm fonts/Piazzolla/static/$BASE-backup-fonttools-prep-gasp.otf
    done
fi

echo
echo Order files
if $static; then
    mkdir -p fonts/Piazzolla/static/ttf
    mkdir -p fonts/Piazzolla/static/otf
    mv fonts/Piazzolla/static/*.otf fonts/Piazzolla/static/otf
    mv fonts/Piazzolla/static/*.ttf fonts/Piazzolla/static/ttf
fi
for f in fonts/Piazzolla/variable/*-VF*; do mv "$f" "${f//-VF/[opsz,wght]}"; done
cp extra/Thanks.png fonts/Piazzolla
cp LICENSE.txt fonts/Piazzolla

echo
echo Freezing Small Caps
cp -r fonts/Piazzolla fonts/PiazzollaSC
cd fonts/PiazzollaSC
for f in variable/*; do pyftfeatfreeze -f 'smcp' -S -U SC "$f" "${f//Piazzolla/PiazzollaSC}" && rm "$f"; done
if $static; then
    for f in static/otf/*; do pyftfeatfreeze -f 'smcp' -S -U SC "$f" "${f//Piazzolla/PiazzollaSC}" && rm "$f"; done
    for f in static/ttf/*; do pyftfeatfreeze -f 'smcp' -S -U SC "$f" "${f//Piazzolla/PiazzollaSC}" && rm "$f"; done
fi
cd ../..
