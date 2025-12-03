# `tiankaima/pytorch`

Repacked of `nvidia/pytorch`, add miniconda and some useful tools.

`mirrors.ustc.edu.cn` is used whenever possible (ubuntu, conda, pip, etc) to speed things up in production (the lab I'm working in)

To deploy, caching `miniconda` and `pip` packages is recommended, mounting guide:

```bash
-v /opt/miniconda/pkgs:/root/miniconda/pkgs
-v /opt/pip:/home/user/.cache/pip
```
