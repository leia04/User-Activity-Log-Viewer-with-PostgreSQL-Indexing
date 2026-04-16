-- fix random seed for reproducibility of this batch only
SELECT setseed(0.42);

-- general users (30k)
INSERT INTO activity_logs (user_id, action_type, resource, ts, metadata)
SELECT
  (random()*999)::int + 1,
  (ARRAY['login','logout','view','click','purchase','search','add_to_cart','checkout'])[(random()*7)::int + 1],
  (ARRAY['/','/home','/feed','/search','/product/1','/product/2','/cart','/checkout','/profile'])[(random()*8)::int + 1],
  NOW() - (random() * interval '180 days'),
  (ARRAY['Chrome','Safari','Firefox','Mobile'])[(random()*3)::int + 1]
FROM generate_series(1, 30000);

-- skewed users (22k, includes 322)
INSERT INTO activity_logs (user_id, action_type, resource, ts, metadata)
SELECT
  (ARRAY[12,34,56,78,90,101,123,145,167,189,210,234,256,278,300,322,356,400,512,963])[(random()*19)::int + 1],
  (ARRAY['login','logout','view','click','purchase','search','add_to_cart','checkout'])[(random()*7)::int + 1],
  (ARRAY['/','/home','/feed','/search','/product/1','/product/2','/cart','/checkout','/profile'])[(random()*8)::int + 1],
  NOW() - (random() * interval '180 days'),
  (ARRAY['Chrome','Safari','Firefox','Mobile'])[(random()*3)::int + 1]
FROM generate_series(1, 22000);