CREATE TABLE jokes (
  id SERIAL PRIMARY KEY,
  setup TEXT NOT NULL,
  punchline TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO jokes (setup, punchline) VALUES
('Why do programmers prefer dark mode?', 'Because light attracts bugs.'),
('How many programmers does it take to change a light bulb?', 'None, that''s a hardware problem.'),
('Why was the JavaScript developer sad?', 'Because he didn''t Node how to Express his feelings.'),
('What do you call a fake noodle?', 'An impasta.'),
('Why do Java developers wear glasses?', 'Because they cannot C#.'),
('How does a developer make a milkshake?', 'They give the browser a shake event.'),
('Why do Python programmers wear glasses?', 'Because they can''t C.'),
('What is a programmer''s favorite place?', 'Debug Mode.');
