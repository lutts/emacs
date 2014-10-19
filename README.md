# My Emacs configurations #


# 启动多个emacs实例 #
因为使用了server模式，只能启动一个实例，如果要启用多个实例，需要新建一个用户，然后使用以下方式登录

```
ssh -i /home/lutts/.ssh/lutts -Y emacs1@127.0.0.1 "emacs -mm"
```
