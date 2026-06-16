# present-gpu

## Disclaimer
This project or the binary files available in the `Releases` area are `NOT` delivered and/or released by Red Hat. This is an independent project to help check `Nodes` and `Pods` for `GPUs`.

---

## Purpose
The main idea of this project is to describe the nodes and pods that have and are consuming GPU's.

## How to Use it

Download it
```
wget https://raw.githubusercontent.com/QikfixAI/present-gpu/refs/heads/main/present-gpu.sh
chmod +x present-gpu.sh
```

Let' check the options
```
./present-gpu.sh --help
'./present-gpu.sh' - Execute a single run
or
'./present-gpu.sh -w' - Update every second
```

If you would like to execute a single run
```
./present-gpu.sh
=== Node: ocpsrv.ocp40.king.lab ===
Total GPUs: 2
Pods using GPUs:

NS                                       POD                                                                              GPU_Requests    GPU_Limits
big-project-over-here-in-2026            wb01-gpu-0                                                                       2               2
```

and if you would like to keep this live
```
./present-gpu.sh -w
```
and the output
```
Every 2.0s: bash -c full_run

=== Node: ocpsrv.ocp40.king.lab ===
Total GPUs: 2
Pods using GPUs:

NS                                       POD                                                                              GPU_Requests    GPU_Limits
demo                                     deepseek-aideepseek-r1-distill-predictor-844fbfc965-4cvzk                        1               1
demo                                     redhataiministral-3-3b-instruc-predictor-7b848d75f6-82r75                        1               1
```

To exit, just press `CTRL+C`

That's all! Enjoy it!<br>
Waldirio