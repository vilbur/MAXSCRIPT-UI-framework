clearListener()


--struct _test ( prop )
--
--
--mapped function testFn p = print (p as string)
--
--
--mapped function testFn item  =(
--
-- item.prop += "X"
--)
--
--test = #()
--arr = #( _test("A"), _test("B")  )
----arr = #( red , green , blue )
----a = #( 0,1,2 )
--
--test = testFn arr
--format "arr:	% \n" arr
--format "test:	% \n" test
----testFn a

--struct _test ( prop )

--result = #()
--
--mapped function testFn p &result = ( append result (toUpper  p) )
--
--
--
----arr = #( _test("A"), _test("B")  )
----arr = #( red , green , blue )
--arr = #( "red" , "green" , "blue" )
----a = #( 0,1,2 )
--
--testFn arr result
--
--
--format "arr:	% \n" arr
--format "result:	% \n" result






mapped function testFn str = ( append  str "X"  )


arr = #( "red" , "green" , "blue" )

testFn arr

format "arr:	% \n" arr





--mapped function testFn arr &result = ( append result (  "X" + arr ) )
--
--
--arr = #( "red" , "green" , "blue" )
--
--testFn arr (result = #())
--
--format "arr:	% \n" arr
--format "result:	% \n" result
