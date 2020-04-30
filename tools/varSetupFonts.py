font = Glyphs.font
list = """A
Aacute
Adieresis
Agrave
Aring
Atilde
AE
B
C
Ccedilla
D
Eth
E
Eacute
Edieresis
Egrave
F
G
H
I
Iacute
Idieresis
Igrave
J
K
L
M
N
Ntilde
O
Oacute
Odieresis
Ograve
Oslash
Otilde
OE
P
Thorn
Q
R
S
Scaron
T
U
Uacute
Udieresis
Ugrave
V
W
X
Y
Yacute
Ydieresis
Z
Zcaron
Oslash.rl-Weight_118_208
a
aacute
adieresis
agrave
aring
atilde
ae
b
c
ccedilla
d
eth
e
eacute
edieresis
egrave
f
g
h
i
iacute
idieresis
igrave
j
k
l
m
n
ntilde
o
oacute
odieresis
ograve
oslash
otilde
oe
p
thorn
q
r
s
scaron
germandbls
t
u
uacute
udieresis
ugrave
v
w
x
y
yacute
ydieresis
z
zcaron
oslash.rl-Weight_118_208
oslash.sc.rl-Weight_118_208
a.sc
aacute.sc
adieresis.sc
agrave.sc
aring.sc
atilde.sc
ae.sc
b.sc
c.sc
ccedilla.sc
d.sc
eth.sc
e.sc
eacute.sc
edieresis.sc
egrave.sc
f.sc
g.sc
h.sc
i.sc
iacute.sc
idieresis.sc
igrave.sc
j.sc
k.sc
l.sc
m.sc
n.sc
ntilde.sc
o.sc
oacute.sc
odieresis.sc
ograve.sc
oslash.sc
otilde.sc
oe.sc
p.sc
thorn.sc
q.sc
r.sc
s.sc
scaron.sc
germandbls.sc
t.sc
u.sc
uacute.sc
udieresis.sc
ugrave.sc
v.sc
w.sc
x.sc
y.sc
yacute.sc
ydieresis.sc
z.sc
zcaron.sc
mu
zero
one
two
three
four
five
six
seven
eight
nine
period
comma
colon
semicolon
ellipsis
exclam
exclamdown
question
questiondown
periodcentered
bullet
asterisk
numbersign
slash
backslash
parenleft
parenright
braceleft
braceright
bracketleft
bracketright
hyphen
endash
emdash
underscore
quotesinglbase
quotedblbase
quotedblleft
quotedblright
quoteleft
quoteright
guillemetleft
guillemetright
guilsinglleft
guilsinglright
quotedbl
quotesingle
space
cent
dollar
florin
sterling
yen
plus
multiply
divide
equal
greater
less
plusminus
asciitilde
logicalnot
asciicircum
at
ampersand
paragraph
section
copyright
registered
trademark
degree
bar
brokenbar
dagger
daggerdbl
cent.rl-Weight_118_208
dollar.rl-Weight_118_208
dieresiscomb
gravecomb
acutecomb
circumflexcomb
tildecomb
macroncomb
cedillacomb
dieresis
grave
acute
circumflex
tilde
macron
cedilla
idotless
jdotless
dieresiscomb
dotaccentcomb
gravecomb
acutecomb
hungarumlautcomb
caroncomb.alt
circumflexcomb
caroncomb
brevecomb
ringcomb
tildecomb
macroncomb
hookabovecomb
dblgravecomb
breveinvertedcomb
commaturnedabovecomb
horncomb
dotbelowcomb
dieresisbelowcomb
commaaccentcomb
cedillacomb
ogonekcomb
brevebelowcomb
macronbelowcomb
strokeshortcomb
strokelongcomb
slashshortcomb
slashlongcomb
macroncomb.long
ypogegrammenicomb
ypogegrammenicomb.long
brevecomb-cy
"""
charset = list.splitlines()
deletableGlyphs = [g.name for g in font.glyphs if g.name not in charset]

font.disableUpdateInterface()

# remove
for glyph in deletableGlyphs:
    del(font.glyphs[glyph])

#reset features
features = [t.name for t in font.features]
for f in features:
    del(font.features[f])

featurePrefixes = [t.name for t in font.featurePrefixes]
for f in featurePrefixes:
    del(font.featurePrefixes[f])

classes = [t.name for t in font.classes]
for f in classes:
    del(font.classes[f])

font.updateFeatures()

font.enableUpdateInterface()

Glyphs.showNotification('Setup fonts', 'The setup fonts have been done')