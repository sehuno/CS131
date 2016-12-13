import java.util.concurrent.atomic.AtomicInteger;

public class BetterSorryState implements State {
    private AtomicInteger[] value;
    private byte maxval;

    BetterSorryState(byte[] v, byte m) {
        value = new AtomicInteger[v.length];
        for (int i = 0; i < v.length; i++) 
            value[i] = new AtomicInteger((int) v[i]);
        maxval = m;
    }

    BetterSorryState(byte[] v) { 
        this(v, (byte) 127);
    }

    public int size() {
        return value.length;
    }

    public byte[] current() {
        byte[] byte_array = new byte[value.length];
        for (int i = 0; i < value.length; i++) 
            byte_array[i] = (byte) value[i].get();
        return byte_array;
    }

    public boolean swap(int i, int j) {
        if (value[i].get() <= 0 || value[j].get() >= maxval) 
            return false;
        value[i].getAndDecrement();
        value[j].getAndIncrement();
        return true;
    }
}