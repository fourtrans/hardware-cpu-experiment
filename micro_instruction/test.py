def foo(a):
    def foo2():
        print(a)
    foo2()

foo(3)