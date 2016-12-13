import java.util.concurrent.atomic.AtomicIntegerArray;

public class GetNSetState implements State{
    private AtomicIntegerArray value;
    private byte maxval;

    GetNSetState(byte[] v, byte m) {
        value = new AtomicIntegerArray(v.length);
        maxval = m;
        for (int i = 0; i < v.length; i++) 
            value.set(i, (int) v[i]);
    }

    GetNSetState(byte[] v) {
        this(v, (byte) 127);
    }

    public int size() { return value.length(); }

    public byte[] current() {
        byte[] byte_array = new byte[value.length()];
        for (int i = 0; i < value.length(); i++) 
            byte_array[i] = (byte) value.get(i);
        return byte_array;
    }

    public boolean swap(int i, int j) {
        if (value.get(i) <= 0 || value.get(j) >= maxval) 
            return false;
        value.set(i, value.get(i)-1);
        value.set(j, value.get(j)+1);
        return true;
    }
}