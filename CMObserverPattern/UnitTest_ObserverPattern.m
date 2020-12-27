%% Observer Pattern Test

p = Publisher('Pub-1');

s1 = Subscriber('Sub-1');
s2 = Subscriber('Sub-2');

p.subscribe(s1);
p.subscribe(s2);

%%

p.setState('OUT_OF_SERVCICE');

%%

p.setState('RUNNING');
p.setState('RUNNING');