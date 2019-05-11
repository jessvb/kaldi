This directory contains some pre-built files for various purpose,
the arpa_gen.sh is the same as local/arpa_gen.sh, which is used
to generate the arpa format model, which is the task.arpabo in
this directory. phones contains all the phones occured in the
phones part of the lexicon.txt, theses phones are taken from 
the corpus, you can use fmtphone.sh to generate the phones.txt, 
which is the phones table that can be recognized by kaldi. The 
lexicon.txt is provided by the corpus, and the lexicon_nosil.txt
contains all the non silence lexicons in the lexicon.txt. transcrp.tbl
is the transcription table, which I generated use local/trn_gen.sh
