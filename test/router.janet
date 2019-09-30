(import tester :prefix "")
(import ../src/router :as router)


(deftest "Compile routes"
  (def compiled-routes 
    (router/compile-routes {"/" :root "/home/:id" :home}))

  (test "are compiled" compiled-routes)
  (test "has all actions" 
        (deep= @[:home :root] (values compiled-routes)))
  (test "route is peg"
        (= :core/peg (type (first (keys compiled-routes))))))

(deftest "Lookup uri"
  (def compiled-routes 
    (router/compile-routes {"/" :root "/home/:id" :home}))

  (test "lookup"
        (deep= (router/lookup compiled-routes "/home/3") 
               '(:home @{:id "3"})))
  (test "lookup root"
        (deep= (router/lookup compiled-routes "/") 
               '(:root @{})))
  (test "lookup rooty"
        (empty? (router/lookup compiled-routes "/home/"))))

(deftest "Router"
  (def router (router/router {"/" :root 
                              "/home/:id" :home 
                              :not-found :not-found}))
  (test "root"
        (= (router "/") :root))
  (test "home"
        (= (router "/home/3") :home))
  (test "not found"
        (= (router "home") :not-found)))
