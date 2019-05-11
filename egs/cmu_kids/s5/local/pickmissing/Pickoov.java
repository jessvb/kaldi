import java.util.ArrayList;
import java.util.Scanner;

public class Pickoov {
	
	public static void main( String[] argv ) {
		Scanner sc = new Scanner( System.in );
		String str = sc.nextLine();
		String tmp = "";
		ArrayList< String > al = new ArrayList< String >();
		
		for( int i = 0; i < str.length(); i++ ) {
			Character c = str.charAt( i );
			if( ' ' == c ) {
				if( check( al, tmp ) ) al.add( tmp );
				tmp = "";
			} else if ( i == str.length() - 1 ) {
				tmp += c;
				if( check( al, tmp ) ) al.add( tmp );
				tmp = "";
			} else {
				tmp += c;
			}
		}
		printList( al );
	}
	
	private static boolean check( ArrayList< String > al, String str ) {

		for( int i = 0; i < al.size(); i++ ) {
			if( str.equals( al.get( i ) ) ) return false;
		}
		return true;
	}
	
	private static void printList( ArrayList< String > al ) {
		for( int i = 0; i < al.size(); i++ ) {
			System.out.println( al.get( i ) );
		}
	}
}
