CC = gcc -I /usr/lib64/erlang/erts-9.3.3.9/include -fpic

complie:
	 $(CC) -o complex6_nif.so  -shared complex.c complex6_nif.c

clean:
	rm complex6_nif.so complex6.beam
