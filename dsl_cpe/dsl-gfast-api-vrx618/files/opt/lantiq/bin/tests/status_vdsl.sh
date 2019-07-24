echo "usage: ${0} [line] [result substring]"
TIME_ID=`date +%H%M%S`
RES_FILE=${0}_results_${2}_${TIME_ID}.txt
STATUS_FILE_EXT=${2}_${TIME_ID}
if [ "$1" == "" ] ; then
   line=8
else
   line=$1
fi
. /opt/lantiq/bin/alias_dsl.sh
nReturn=0

echo ${0} Results                                  > $RES_FILE
dsl vig                                     >> $RES_FILE
dsl lvig -1                                 >> $RES_FILE

echo_all()
{
   echo "$@" >> $RES_FILE
   echo "$@" 
}

# trace and return error if not success 
test_command()
{
   echo_all "$@" 
   RESULT=`eval dsl $@`
   echo $RESULT >> $RES_FILE

   echo $RESULT | grep -q nReturn=0
   if [ $? -ne 0 ]; then
      echo_all "Error! Last call $@ returned: $RESULT "
      nReturn=$(($nReturn+1))
   fi
}

# trace and return error if not error
test_command_neg()
{
   echo_all "$@" 
   RESULT=`eval dsl $@`
   echo $RESULT >> $RES_FILE

   echo $RESULT | grep -q nReturn=-
   if [ $? -ne 0 ]; then
      echo_all "Error! Last call $@ returned: $RESULT "
      nReturn=$(($nReturn+1))
   fi
}

log_command()
{
   echo_all "$@" 
   dsl $@ >> $RES_FILE
}

catch_msg()
{
   # catch a string from the message dump
   # deamon needs to be started with c option
   # ./dsl_daemon -f ../firmware/xco_hw_rev2m_b.bin -c 1
   # usage: catch_msg <string to catch> [<command to execute>]

   # synchronize the file now
   killall tail
   tail -f /tmp/pipe/dms0_dump  | grep -A 2 $1  >> $RES_FILE &
   dsl dmls 9 40
   log_command $2
   dsl dmls 9 0
   sleep 5
   # synchronize the file now
   killall tail
}

wait_for_msg()
{
   # catch a string from the message dump
   # deamon needs to be started with c option
   # ./dsl_daemon -f ../firmware/xco_hw_rev2m_b.bin -c 1
   # usage: catch_msg <string to catch> <seconds to wait>

   # synchronize the file now
   killall tail
   tail -f /tmp/pipe/dms0_dump  | grep -A 2 $1  >> $RES_FILE &
   dsl dmls 9 40
   sleep $2
   dsl dmls 9 0
   # synchronize the file now
   killall tail
}

catch_evt()
{
   # catch a string from the event dump
   # usage: catch_evt <"string to catch"> <"command to execute"> <time to wat>

   # synchronize the file now
   killall tail
   tail -f /tmp/pipe/dms0_event  | grep -A 2 $1  >> $RES_FILE &
   log_command $2
   sleep $3
   # synchronize the file now
   killall tail
}

# trace all messages
#tail -f /tmp/pipe/dms0_event >> $RES_FILE &
#test_command dmls 9 40

# start the testsequence here
echo_all "============ Test 1 ==============="
echo_all "request various VDSL status"

#only VDSL
test_command G997_UsPowerBackOffStatusGet ${line}

for DIR in 0 1 ; do
   test_command AuxLineInventoryGet ${line} $DIR
   
# Debug Status VDSL
   test_command PSDMaskDefaultGet ${line} $DIR 100
   test_command LineSpectrumDefaultGet ${line} $DIR 100
   test_command G997_TransmitSpectrumShapingGet ${line} $DIR 100   
   test_command BandBorderConfigGet ${line} $DIR 
   test_command G997_MedleyReferencePsdStatusGet ${line} $DIR
   test_command G997_MedleyReferencePsdNSCGet ${line} $DIR
done

echo_all "$0 ended with return code $nReturn"
exit $nReturn
