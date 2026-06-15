package net.octacomm.sample.utils;


import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


import net.octacomm.sample.domain.Piece;

public class Utill {
	
	public static boolean stringNullCheck(String str) {
		if(str != null) {
			return !str.isEmpty();
		}
		return false;
	}
	
	/**
     * Piece 리스트를 정리하여 중복 및 과잉 데이터 제거.
     * 규칙:
     *  - 단본, 상단, 하단 → 1개만 유지 (id가 가장 큰 것)
     *  - 중단 → id가 연속적인 2개까지만 유지
     */
    /**public static List<Piece> filterPieces(List<Piece> pieces, int extensivePileUsage) {
        if (pieces == null || pieces.isEmpty()) {
            return Collections.emptyList();
        }

        // name 기준으로 그룹화 (Stream 없이 수동 구현)
        Map<String, List<Piece>> grouped = new HashMap<String, List<Piece>>();
        for (Piece p : pieces) {
            String name = p.getName();
            if (!grouped.containsKey(name)) {
                grouped.put(name, new ArrayList<Piece>());
            }
            grouped.get(name).add(p);
        }

        List<Piece> filtered = new ArrayList<Piece>();

        // 그룹별로 처리
        for (Map.Entry<String, List<Piece>> entry : grouped.entrySet()) {
            String name = entry.getKey();
            List<Piece> list = entry.getValue();

            if ("단본".equals(name) || "상단".equals(name) || "하단".equals(name)) {
                // id 내림차순 정렬 → 첫 번째만 유지
                Collections.sort(list, new Comparator<Piece>() {
                    public int compare(Piece a, Piece b) {
                        return b.getId() - a.getId(); // 내림차순
                    }
                });
                filtered.add(list.get(0));

            } else if ("중단".equals(name)) {
                // id 오름차순 정렬
                Collections.sort(list, new Comparator<Piece>() {
                    public int compare(Piece a, Piece b) {
                        return a.getId() - b.getId();
                    }
                });

                // 연속된 id 그룹 묶기
                List<List<Piece>> groupedMiddle = new ArrayList<List<Piece>>();
                List<Piece> temp = new ArrayList<Piece>();
                Piece prev = null;

                for (Piece p : list) {
                    if (prev == null || p.getId() == prev.getId() + 1) {
                        temp.add(p);
                    } else {
                        groupedMiddle.add(new ArrayList<Piece>(temp));
                        temp.clear();
                        temp.add(p);
                    }
                    prev = p;
                }
                if (!temp.isEmpty()) {
                    groupedMiddle.add(new ArrayList<Piece>(temp));
                }

                // 각 연속 그룹에서 최대 2개까지만 유지 extensivePileUsage 가 0보다 크면 4개까지
                for (List<Piece> group : groupedMiddle) {
                    int count = 0;
                    for (Piece p : group) {
                        filtered.add(p);
                        count++;
                        if (count >= (extensivePileUsage > 0 ? 4 : 2)) break;
                    }
                }
            }
        }

        // id 오름차순 정렬 (보기 편하게)
        Collections.sort(filtered, new Comparator<Piece>() {
            public int compare(Piece a, Piece b) {
                return a.getId() - b.getId();
            }
        });

        return filtered;
    }**/
	
	public static List<Piece> filterPieces(List<Piece> pieces, int extensivePileUsage) {
	    if (pieces == null || pieces.isEmpty()) {
	        return Collections.emptyList();
	    }

	    // name 기준 그룹화
	    Map<String, List<Piece>> grouped = new HashMap<String, List<Piece>>();
	    for (Piece p : pieces) {
	        String name = p.getName();
	        List<Piece> list = grouped.get(name);
	        if (list == null) {
	            list = new ArrayList<Piece>();
	            grouped.put(name, list);
	        }
	        list.add(p);
	    }

	    List<Piece> result = new ArrayList<Piece>();

	    // 1. 단본 (id 가장 큰 것 1개)
	    addSingle(grouped.get("단본"), result, true);

	    // 2. 하단 (id 가장 큰 것 1개)
	    addSingle(grouped.get("하단"), result, true);

	    // 3. 중단
	    System.err.println("extensivePileUsage : " + extensivePileUsage);
	    
	    addMiddle(grouped.get("중단"), result, extensivePileUsage);

	    // 4. 상단 (id 가장 큰 것 1개)
	    addSingle(grouped.get("상단"), result, true);

	    return result;
	}
	private static void addSingle(List<Piece> list, List<Piece> out, boolean max) {
	    if (list == null || list.isEmpty()) return;

	    Piece target = list.get(0);
	    for (Piece p : list) {
	        if (max && p.getId() > target.getId()) {
	            target = p;
	        }
	    }
	    out.add(target);
	}
	private static void addMiddle(List<Piece> list, List<Piece> out, int extensivePileUsage) {
	    if (list == null || list.isEmpty()) return;

	    int limit = extensivePileUsage > 0 ? 4 : 2;

	    List<Piece> temp = new ArrayList<Piece>();
	    Piece prev = null;

	    for (Piece p : list) { // ★ 입력 순서 그대로
	        if (prev == null || p.getId() == prev.getId() + 1) {
	            temp.add(p);
	        } else {
	            addLimited(temp, out, limit);
	            temp.clear();
	            temp.add(p);
	        }
	        prev = p;
	    }
	    addLimited(temp, out, limit);
	}

	private static void addLimited(List<Piece> src, List<Piece> out, int limit) {
	    for (int i = 0; i < src.size() && i < limit; i++) {
	        out.add(src.get(i));
	    }
	}

	
	
}
