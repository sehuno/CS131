javac SwapTest.java NullState.java State.java SynchronizedState.java UnsynchronizedState.java BetterSafeState.java BetterSorryState.java GetNSetState.java UnsafeMemory.java
echo "java UnsafeMemory Null 4 1000 6 5 6 3 0 3"
java UnsafeMemory Null 4 1000 6 5 6 3 0 3 
echo "java UnsafeMemory Unsynchronized 4 1000 6 5 6 3 0 3"
java UnsafeMemory Unsynchronized 4 1000 6 5 6 3 0 3 
echo "java UnsafeMemory Synchronized 4 1000 6 5 6 3 0 3"
java UnsafeMemory Synchronized 4 1000 6 5 6 3 0 3 
echo "java UnsafeMemory GetNSet 4 1000 6 5 6 3 0 3"
java UnsafeMemory GetNSet 4 1000 6 5 6 3 0 3 
echo "java UnsafeMemory BetterSafe 4 1000 6 5 6 3 0 3"
java UnsafeMemory BetterSafe 4 1000 6 5 6 3 0 3 
echo "java UnsafeMemory BetterSorry 4 1000 6 5 6 3 0 3"
java UnsafeMemory BetterSorry 4 1000 6 5 6 3 0 3 
echo ""
echo "java UnsafeMemory Synchronized 6 100000 6 5 6 3 0 3"
java UnsafeMemory Synchronized 6 100000 6 5 6 3 0 3 
echo "java UnsafeMemory BetterSafe 6 100000 6 5 6 3 0 3"
java UnsafeMemory BetterSafe 6 100000 8 5 6 0003 0 3 
echo "java UnsafeMemory BetterSorry 6 100000 6 5 6 3 0 3"
java UnsafeMemory BetterSorry 6 100000 6 5 6 3 0 3 
echo ""
echo "java UnsafeMemory Synchronized 8 1000000 6 5 6 3 0 3"
java UnsafeMemory Synchronized 8 1000000 6 5 6 3 0 3 
echo "java UnsafeMemory BetterSafe 8 1000000 6 5 6 3 0 3"
java UnsafeMemory BetterSafe 8 1000000 8 5 6 0003 0 3 
echo "java UnsafeMemory BetterSorry 8 1000000 6 5 6 3 0 3"
java UnsafeMemory BetterSorry 8 1000000 6 5 6 3 0 3 
echo ""
echo "java UnsafeMemory Synchronized 12 10000000 6 5 6 3 0 3"
java UnsafeMemory Synchronized 12 10000000 6 5 6 3 0 3 
echo "java UnsafeMemory BetterSafe 8 1000000 6 5 6 3 0 3"
java UnsafeMemory BetterSafe 12 10000000 8 5 6 0003 0 3 
echo "java UnsafeMemory BetterSorry 8 1000000 6 5 6 3 0 3"
java UnsafeMemory BetterSorry 12 10000000 6 5 6 3 0 3 