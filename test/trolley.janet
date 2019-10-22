(import tester :prefix "")
(import ../trolley :as trolley)

(def config "Routes' config for all tests"
  {"/" :root "/home/:id" :home "/real-thing.json" :real-thing})

(deftest "Compile routes"
  (let [compiled-routes (trolley/compile-routes config)
        actions (values compiled-routes) 
        routes (keys compiled-routes)]
    (test "are compiled" compiled-routes)
    (test "has root action" 
          (some |(= $ :root) actions))
    (test "has home action" 
          (some |(= $ :home) actions))
    (test "routes are all PEGs"
          (all |(= (type $) :core/peg) routes))))

(deftest "Lookup uri"
  (let [compiled-routes (trolley/compile-routes config)]
    (test "lookup"
         (deep= (trolley/lookup compiled-routes "/home/3") 
                [:home @{:id "3"}]))
   (test "lookup root"
         (deep= (trolley/lookup compiled-routes "/") 
                [:root @{}]))
   (test "lookup real thing"
         (deep= (trolley/lookup compiled-routes "/real-thing.json") 
                [:real-thing @{}]) )
   (test "lookup rooty"
         (empty? (trolley/lookup compiled-routes "/home/")))))

(deftest "Router"
  (let [router (trolley/router config)]
    (test "root"
          (deep= (router "/") [:root @{}]))
    (test "home"
          (deep= (router "/home/3") [:home @{:id "3"}]))
    (test "real thing json"
          (deep= (router "/real-thing.json") [:real-thing @{}]))
    (test "not found"
          (empty? (router "home")))))
