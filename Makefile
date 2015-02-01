#CXX      = g++
CXX      = libtool --mode=compile gcc -g -O
CFLAGS   = -Wall -fPIC
CPPFLAGS = $(CFLAGS) -I/usr/local/include -L/usr/local/lib -Iinclude/

LIBRARIES= rabbitmq
LIBS     = $(addprefix -l,$(LIBRARIES))

LIBNAME  = amqpcpp
LIBFILE  = lib$(LIBNAME).a

SOURCES  = src/AMQP.cpp src/AMQPBase.cpp src/AMQPException.cpp src/AMQPMessage.cpp src/AMQPExchange.cpp src/AMQPQueue.cpp
EXFILES  = example_publish.cpp example_consume.cpp example_get.cpp
EXAMPLES = $(EXFILES:.cpp=)
OBJECTS  = $(SOURCES:.cpp=.o)
LOOBJECTS  = $(SOURCES:.cpp=.lo)
SOLIBRARY = libamqpcpp.la
ALIBRARY = libamqpcpp.a


all: lib $(EXAMPLES)

lib: $(SOLIBRARY) $(ALIBRARY)
	libtool --mode=link gcc -g -O -o libamqpcpp.la $(LOOBJECTS) -rpath /usr/lib/x86_64-linux-gnu/

install:
	libtool --mode=install install -c libamqpcpp.la /usr/lib/x86_64-linux-gnu/libamqpcpp.la
	libtool --finish /usr/lib/x86_64-linux-gnu/

$(ALIBRARY): $(OBJECTS)
	$(AR) rcs $@ $(OBJECTS)

$(SOLIBRARY): $(OBJECTS)
	libtool --mode=link gcc -g -O -o libamqpcpp.la $(LOOBJECTS) -rpath /usr/lib/x86_64-linux-gnu/
	#$(CXX) $(CPPFLAGS) -shared -o $(SOLIBRARY) $(OBJECTS)

$(EXAMPLES): $(addprefix examples/,$(EXFILES)) $(LIBFILE)
	$(CXX) $(CPPFLAGS) -o $@ examples/$@.cpp $(LIBFILE) $(LIBS)

clean:
	rm -f $(OBJECTS) $(EXAMPLES) $(LIBFILE)
