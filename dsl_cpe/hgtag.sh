#!/bin/sh

hgtag ()
{
        ISO_DATE=`date +%Y%m%dT%H%M00%z`
        HG_BRANCH=`hg branch`
        HG_TAG_FIXED=tested_${HG_BRANCH}_${ISO_DATE}
        HG_TAG_FLOATING=tested_${HG_BRANCH}
        HG_REVISION=`hg log -l1 -b $HG_BRANCH`
        HG_VERSION=`echo "$HG_REVISION" | head -n1 | awk '{print $2}'`
        echo -en "\n\033[32mTag(Floating):\033[33m $HG_TAG_FLOATING \033[32mTag(Fixed):\033[33m $HG_TAG_FIXED\033[00m\n"
        echo "$HG_REVISION"
        echo -en "\nRevision to tag: \033[33m$HG_VERSION\033[00m\n"
        echo -en "\nContinue..? (y/N): "
        read hg_inp_val
        ([ -n "$hg_inp_val" ] && [ "$hg_inp_val" = "Y" -o "$hg_inp_val" = "y" ]) && {
                hg tag -f -r $HG_VERSION $HG_TAG_FLOATING $HG_TAG_FIXED
                [ $? -eq 0 ] && {
                        echo -en "\n--------- TAGS Created ---------\n"
                        hg log -v -b `hg branch` --color=auto -l2
                        echo -en "Push changes? (y/N): "
                        read hg_push_val
                        ([ -n "$hg_push_val" ] && [ "$hg_push_val" = "Y" -o "$hg_push_val" = "y" ]) && {
                                hg push || echo -en "\nPush failed..!! Please re-check.\n"
                        } || >&-
                } || echo -en "\nTag creation failed!!\n"
        }
}

hgtag;
