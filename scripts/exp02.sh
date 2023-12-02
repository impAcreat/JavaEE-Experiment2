# exp args
user=$1
thread_num=$2
ramp_time=$3
exp=$4

if [ "$5" = "true" ]; then
	index="with_index"
elif [ "$5" = "false" ]; then
	index="without_index"
fi

if [ "${exp}" = "Write" ] && [ "${index}" = "with_index" ]; then
	num_index="_$6"
fi

jmx_path="jmx/exp02/${exp}Order.jmx"
jtl_path="jtl/exp02/${user}/${exp}/${index}"
res_path="result/exp02/${user}/${exp}/${index}${num_index}/${thread_num}-${ramp_time}"

mkdir -p ${jtl_path}
rm -f ${jtl_path}/${thread_num}-${ramp_time}.jtl

mkdir -p ${res_path}
rm -rf ${res_path}/*

sleep 5

ls ${res_path}

cmd="sed -i '22c \\\\t    <stringProp name=\"Argument.value\">${thread_num}</stringProp>' ${jmx_path}"

echo $cmd
eval $cmd

cmd="sed -i '27c \\\\t    <stringProp name=\"Argument.value\">${ramp_time}</stringProp>' ${jmx_path}"

echo $cmd
eval $cmd

cmd="jmeter -n -t ${jmx_path} -l ${jtl_path}/${thread_num}-${ramp_time}.jtl"

echo $cmd
eval $cmd

cmd="jmeter -g ${jtl_path}/${thread_num}-${ramp_time}.jtl -o ${res_path}"

echo $cmd
eval $cmd
