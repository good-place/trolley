(import tester :prefix "")
(import ../src/trolley :as trolley)


(deftest "Compile routes"
  (def compiled-routes 
    (trolley/compile-routes {"/" :root "/home/:id" :home}))

  (test "are compiled" compiled-routes)

  (def actions (values compiled-routes))
  (test "has root action" 
        (some |(= :root $) actions))
  (test "has home action" 
        (some |(= :home $) actions))

  (def first-route (first (keys compiled-routes)))
  (test "route is peg"
        (= :core/peg (type first-route))))

(deftest "Lookup uri"
  (def compiled-routes 
    (trolley/compile-routes {"/" :root "/home/:id" :home}))

  (test "lookup"
        (deep= (trolley/lookup compiled-routes "/home/3") 
               [:home @{:id "3"}]))
  (test "lookup root"
        (deep= (trolley/lookup compiled-routes "/") 
               [:root @{}]))
  (test "lookup rooty"
        (empty? (trolley/lookup compiled-routes "/home/"))))

(deftest "Router"
  (def router (trolley/router {"/" :root 
                              "/home/:id" :home}))
  (test "root"
        (deep= (router "/") [:root @{}]))
  (test "home"
        (deep= (router "/home/3") [:home @{:id "3"}]))
  (test "not found"
        (empty? (router "home"))))
