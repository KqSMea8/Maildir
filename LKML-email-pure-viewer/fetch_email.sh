# #!/bin/bash

echo "start time: `date`"
echo "" > .procmail/pmlog
# getmail -a -d

for i in `ls -1 -d */ 2> /dev/null`
do
cd ${i}

if [ -d "cur" ]; then 
    rm -rf cur
fi
if [ -d "tmp" ]; then 
    rm -rf tmp
fi
if [ -d "new" ]; then 
    mv new/* .
fi
if [ -d "new" ]; then 
    rm -rf new
fi

#for var in `ls -1 *.mac4dev.local`
size=`ls -1 *.likexu-MOBL1 2> /dev/null | wc -l`
if [ ${size} -gt 0 ]; then
for var in `ls -1 *.likexu-MOBL1 2> /dev/null`
do
    SUBJECT=`cat ${var} | grep  "Subject: " | head -n1 | sed 's/Subject: //g' | sed 's/\// /g' | sed 's/:/ /g'| sed 's/\./ /g' | sed 's/-/ /g' | tr -d '[:punct:]' | sed 's/  / /g' | sed 's/ /_/g'`
    NAME=`cat ${var} | grep  "From: " | head -n1 | sed 's/From: //g'`
    date=`cat ${var} | grep  "Date: " | head -n1 | sed 's/Date: //g'`
    DATE=`gdate -d "${date}" +%Y_%m_%d_%H_%M_%S`
    IS_MAINTAINER=`cat ../MAINTAINERS | grep "${NAME}" | wc -l`

    if [ ! -d "${NAME}" ]; then 
        mkdir "${NAME}"
    fi

    mv ${var} "${NAME}"/
    cd "${NAME}"/
    mv ${var} ${DATE}_${SUBJECT}.eml
    cd .. 
done
fi

cd ..
done

for i in `seq 6 1 7`
do
# TODAY=`gdate +%Y_%m_%d`
TODAY="2018_11_0${i}"
# TODAY="2018_10_*"
FILE=../kernel_fanaticism/${TODAY}.txt
echo "" > ${FILE}
for i in `ls -1 -d */ 2> /dev/null`
do
cd ${i}
    a=`grep -r "Subject: " | grep ${TODAY} | awk -F "Subject:" '{print $2}' | sort | uniq | wc -l`
    if [ ${a} -gt 0 ]; then  
    echo ${i} >> ../${FILE}
    echo "=============" >> ../${FILE}
    grep -r "Subject: " | grep ${TODAY} | awk -F "Subject:" '{print $2}' | sort | uniq -c | sort -nr >> ../${FILE}
    echo "\n" >> ../${FILE}
    fi
cd ..
done
done

rm -rf stable
rm -rf .procmail/pmlog
echo "end time: `date`"
echo "git add .;git commit -m \"sync at \`date\`\""
email_num=`find . | grep ".eml" | wc -l`
echo "The number of emails is up to ${email_num}. please limit it to 1000"
